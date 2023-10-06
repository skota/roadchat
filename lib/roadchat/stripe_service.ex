defmodule Roadchat.StripeService do
  # create stripe customer - returns cust_id or error
  def create_customer(user) do
    IO.puts "inside create customer"
    IO.inspect user

    case Stripe.Customer.create(user) do
      {:ok, customer} ->
        IO.inspect customer
        {:ok, customer}
      {:error, err} ->
        IO.puts "stripe cust create: there was an error"
        {:error, err}
      end
  end

  #  -----   store card for usage later ----------
  # create setupintent
  def create_setup_intent(payment_method_id, customer_id) do
    IO.puts "Inside create setup intent"
    case Stripe.SetupIntent.create(%{payment_method: payment_method_id,
                                    customer: customer_id,
                                    usage: "off_session" }) do
      {:ok, setupintent} ->
        # IO.inspect setupintent
        {:ok, setupintent }
      {:error, err} ->
        IO.puts "create setup intent: there was an error"
        {:error, err}
      end
  end

  # confirm setupintent
  def confirm_setup_intent(setup_intent_id, payment_method_id) do
    IO.puts "Inside confirm setup intent"
    case Stripe.SetupIntent.confirm(setup_intent_id , %{payment_method: payment_method_id }) do
      {:ok, setupintent} ->
        # IO.inspect setupintent
        {:ok, setupintent}
      {:error, err} ->
        IO.puts "confirm setup intent: there was an error"
        {:error, err}
      end
  end

  # create paymentmethod - accepts card token, cust id
  def add_payment_method(payment_method, customer_id) do
    case Stripe.PaymentMethod.attach(%{customer: customer_id, payment_method: payment_method}) do
      {:ok, payment_method } ->
        # IO.inspect payment_method

        {:ok, payment_method}
     {:error, err} ->
        IO.puts "Add payment method: there was an error"
        {:error, err}
    end
  end

  # ---- process payments ------------------

  # create charge

  def create_charge(amount, payment_method_id, customer_id) do
    case Stripe.PaymentIntent.create(%{customer: customer_id,
                            payment_method: payment_method_id,
                            amount: amount,
                            currency: "usd",
                            confirm: false}) do
      {:ok, data} ->
        # IO.inspect data
        {:ok, data}
      {:error, err} ->
        IO.puts "Inside create charge: there was an error"
        {:error, err}
    end
  end

  def settle_charge(payment_intent_id, payment_method_id) do
    # Stripe.PaymentIntent.confirm("pi_1Hy8VoBLkjQHf2PYt7v4vNbM", %{payment_method: "pm_1Hy8UMBLkjQHf2PYoLVVMa97"})
    case Stripe.PaymentIntent.confirm(payment_intent_id, %{payment_method: payment_method_id}) do
      {:ok, data} ->
        # IO.inspect data
        {:ok, data}
      {:error, err} ->
        IO.puts "Inide settle charge: there was an error"
        {:error, err}
    end
  end
end
