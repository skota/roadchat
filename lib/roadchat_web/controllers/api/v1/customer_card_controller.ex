defmodule RoadchatWeb.API.V1.CustomerCardController do
  use RoadchatWeb, :controller
  alias Roadchat.Repo
  alias Roadchat.Schemas.CustomerCard
  alias Roadchat.Repos.CustomerCards
  alias Roadchat.Accounts.User
  alias Roadchat.StripeService

  import Stripe

  def get_card(conn, %{"id" => user_id}) do
    case CustomerCards.get_card_by_user(user_id) do
      nil ->
        IO.puts "did not find a card"
        conn
        |> put_status(404)
        |> json(%{error: "not found"})

      card ->
        IO.puts "found card"
        conn
        |> put_status(200)
        |> json(%{  id: card.id,
                    user_id: card.user_id,
                    payment_method_id: card.payment_method_id,
                    card_type: card.card_type,
                    last4: card.card_last_4,
                    exp_month: card.expiry_month,
                    exp_year: card.expiry_year
        })

    end
  end

  def add_customer_card(id, card_params) do
    IO.puts "adding customer card"
    IO.puts "these are the card params"
    IO.inspect card_params
    IO.puts "This is the user: #{id}"

    cust_card= %{
      user_id: id,
      payment_method_id: card_params["paymentmethodId"],
      card_type:  card_params["brand"],
      card_last_4:  card_params["last4"],
      expiry_month:  card_params["expMonth"],
      expiry_year:  card_params["expYear"]
    }

    customer_card = CustomerCards.create_card(cust_card)
    IO.inspect customer_card
    {:ok, customer_card}

  end


  # update user - this should not be here...
  defp update_user(user, params) do
    user = User.update_changeset(user, params)
    |> Repo.update()

    {:ok, user}
  end

  # create stripe customer
  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"params" => params}) do
    {id, "" } = Integer.parse(params["id"])

    IO.puts "inside create"
    IO.inspect params

    # get current user
    user = Repo.get!(User, id)
    name = user.fname <> " " <> user.lname
    IO.puts " this is the user..going to create stripe customer "
    IO.inspect user

    if is_nil(user.stripe_cust_id) do

      with  {:create_customer, {:ok, %Stripe.Customer{} = customer}} <- {:create_customer, StripeService.create_customer(%{name: name,email: user.email})},
            {:setup_intent, {:ok, %Stripe.SetupIntent{} = setupintent}} <- {:setup_intent, StripeService.create_setup_intent(params["paymentmethodId"], customer.id)},
            {:add_payment_method, {:ok, %Stripe.PaymentMethod{} = payment_method}} <- {:add_payment_method, StripeService.add_payment_method(params["paymentmethodId"], customer.id)},
            {:confirm_intent, {:ok, %Stripe.SetupIntent{}= setupintent}} <- {:confirm_intent, StripeService.confirm_setup_intent(setupintent.id, params["paymentmethodId"])},
            {:update_user, {:ok, user}} <- {:update_user, update_user(user, %{stripe_cust_id: customer.id})},
            {:add_customer_card, {:ok, card}} <-  {:add_customer_card, add_customer_card(id, params)} do
        conn
        |> put_status(200)
        |> json(%{stripe_cust_id: customer.id})
      else
        # check for create customer error condition too
        {:create_customer, {:error, %Stripe.Error{} = err}} ->
          IO.puts "create customer error"
          send_err_response(conn, err)

        {:setup_intent, {:error, %Stripe.Error{} = err}} ->
          IO.puts "setup intent error"
          send_err_response(conn, err)

        {:add_payment_method, {:error, %Stripe.Error{} = err}} ->
          IO.puts "add payment method error"
          send_err_response(conn, err)

        {:confirm_intent, {:error, %Stripe.Error{} = err}} ->
          IO.puts "confirm intent error"
          send_err_response(conn, err)

        {:update_user, {:error, %Ecto.Changeset{} = err}} ->
          # extract error from changeset
          IO.puts "update user with stripe id error"
          send_err_response(conn, err)

        {:add_customer_card, {:error, %Ecto.Changeset{} = err}} ->
          IO.puts "add customer card error"
          # extract error from changeset
          send_err_response(conn, err)

      end

    else
      with  {:setup_intent, {:ok, setupintent}} <- {:setup_intent, StripeService.create_setup_intent(params["paymentmethodId"], user.stripe_cust_id)},
            {:add_payment_method, {:ok, data}} <-  {:add_payment_method, StripeService.add_payment_method(params["paymentmethodId"], user.stripe_cust_id)},
            {:confirm_intent, {:ok, setupintent}} <- {:confirm_intent, StripeService.confirm_setup_intent(setupintent.id, params["paymentmethodId"])},
            {:update_user, {:ok, %User{} = user}} <- {:update_user, update_user(user, %{stripe_cust_id: user.stripe_cust_id})},
            {:add_customer_card, {:ok, %CustomerCard{} = card}} <- {:add_customer_card, add_customer_card(user, params)} do
        conn
        |> put_status(200)
        |> json(%{stripe_cust_id: 0})
      else
        # check for create customer error condition too
        {:setup_intent, {:error, %Stripe.Error{} = err}} ->
          send_err_response(conn, err)

        {:add_payment_method, {:error, %Stripe.Error{} = err}} ->
          send_err_response(conn, err)

        {:confirm_intent, {:error, %Stripe.Error{} = err}} ->
          send_err_response(conn, err)

        {:update_user, {:error, %Ecto.Changeset{} = err}} ->
          # extract error from changeset
          send_err_response(conn, err)
        {:add_customer_card, {:error, %Ecto.Changeset{} = err}} ->
          # extract error from changeset
          send_err_response(conn, err)

      end
    end
  end

  def get_card_details_by_paymentmethod(conn, %{"payment_method_id" => payment_method_id}) do
    #
    case Stripe.PaymentMethod.retrieve(payment_method_id) do
      {:ok, payment_method_details} ->
        IO.inspect payment_method_details
        conn
        |> put_status(200)
        |> json(%{
            brand: payment_method_details.card.brand,
            last4: payment_method_details.card.last4,
            exp_month: payment_method_details.card.exp_month,
            exp_year: payment_method_details.card.exp_year
         })
      {:error, %Stripe.Error{}} ->
        conn
        |> put_status(401)
        |> json(%{ message: "Paymentmethod does not exist"})
    end
  end


  defp send_err_response(conn, err) do
    IO.inspect err
    conn
    |> put_status(err.extra.http_status)
    |> json(%{error: err.extra.raw_error["message"]})
  end

end
