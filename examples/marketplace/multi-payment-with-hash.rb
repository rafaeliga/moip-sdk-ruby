# Tip: This setup section generally goes in other files,
# and you access them in your controllers as globals,
# instead of reinstantiating them every time.
gem "moip2"

auth = Moip2::Auth::OAuth.new("502f9ca0eccc451dbcf8c0b940110af1_v2")

client = Moip2::Client.new(:sandbox, auth)

api = Moip2::Api.new(client)

# Here we build the multi order data. You'll get the data from your database
# given your controller input, but here we simplify things with a hardcoded
# example.

# In this example, we create a multi order with two orders for two different
# sellers and two different customers, where the first order of the multi order,
# the seller is the primary receiver, and the second one, the seller is the
# secondary receiver.

multi_order = api.multi_order.create(
  own_id: "meu_id_de_multi_order_#{SecureRandom.hex(10)}",
  orders: [
    {
      own_id: "meu_id_de_order_#{SecureRandom.hex(10)}",
      items: [
        {
          product: "Produto 1",
          quantity: 1,
          detail: "Mais info...",
          price: 3000,
        },
      ],
      customer: {
        ownId: "id_do_cliente1_#{SecureRandom.hex(10)}",
        fullname: "Joao Sousa",
        email: "joao.sousa@email.com",
        birthDate: "1988-12-30",
        taxDocument: {
          type: "CPF",
          number: "22222222222",
        },
        phone: {
          countryCode: "55",
          areaCode: "11",
          number: "66778899",
        },
        shippingAddress:  {
          street: "Avenida Faria Lima",
          streetNumber: 2927,
          complement: 8,
          district: "Itaim",
          city: "Sao Paulo",
          state: "SP",
          country: "BRA",
          zipCode: "01234000",
        },
      },
      receivers: [
        {
          moipAccount: {
            id:  "MPA-D63A62C73A92",
          },
          type: "PRIMARY",
        },
      ],
    },
    {
      own_id: "meu_segundo_id_de_order_#{SecureRandom.hex(10)}",
      items: [
        {
          product: "Produto 2",
          quantity: 1,
          detail: "Mais info...",
          price: 2600,
        },
      ],
      customer: {
        ownId: "id_do_cliente2_#{SecureRandom.hex(10)}",
        fullname: "Joao Sousa",
        email: "joao.sousa@email.com",
        birthDate: "1988-12-30",
        taxDocument: {
          type: "CPF",
          number: "22222222222",
        },
        phone: {
          countryCode: "55",
          areaCode: "11",
          number: "66778899",
        },
        shippingAddress:  {
          street: "Avenida Faria Lima",
          streetNumber: 2927,
          complement: 8,
          district: "Itaim",
          city: "Sao Paulo",
          state: "SP",
          country: "BRA",
          zipCode: "01234000",
        },
      },
      receivers: [
        {
          moipAccount: {
            id: "MPA-D63A62C73A92",
          },
          type: "PRIMARY",
        },
        {
          moipAccount: {
            id: "MPA-HBKKXIFCY1N3",
          },
          type: "SECONDARY",
          amount: {
            fixed: 55,
          },
        },
      ],
    },
    {
      own_id: "meu_terceiro_id_de_order_#{SecureRandom.hex(10)}",
      items: [
        {
          product: "Produto 3",
          quantity: 2,
          detail: "Mais info...",
          price: 4000,
        },
      ],
      customer: {
        ownId: "id_do_cliente3_#{SecureRandom.hex(10)}",
        fullname: "Joao Sousa",
        email: "joao.sousa@email.com",
        birthDate: "1988-12-30",
        taxDocument: {
          type: "CPF",
          number: "22222222222",
        },
        phone: {
          countryCode: "55",
          areaCode: "11",
          number: "66778899",
        },
        shippingAddress:  {
          street: "Avenida Faria Lima",
          streetNumber: 2927,
          complement: 8,
          district: "Itaim",
          city: "Sao Paulo",
          state: "SP",
          country: "BRA",
          zipCode: "01234000",
        },
      },
      receivers: [
        {
          moipAccount: {
            id:  "MPA-D63A62C73A92",
          },
          type: "PRIMARY",
        },
        {
          moipAccount: {
            id: "MPA-HBKKXIFCY1N3",
          },
          type: "SECONDARY",
          amount: {
            percentual: 40,
          },
        },
      ],
    },
  ],
)

# Now with the order ID in hands, you can start creating payments
# It is common to use the `hash` method if you are using client-side
# encryption for card data.
multi_payment = api.multi_payment.create(multi_order.id,
  installment_count: 1,
  funding_instrument: {
    method: "CREDIT_CARD",
    credit_card: {
      # You can generate the following hash using a Moip Javascript SDK
      # where you use the customer credit_card data and your public key
      # to create the hash.
      # Read more about creating credit card hash here:
      # https://dev.moip.com.br/v2.0/docs/criptografia-de-cartao
      hash: "kJHoKZ2bIVFjEFPSQQxbpXL6t5VCMoGTB4eJ4GLHmUz8f8Ny/LSL20yqbn+bZQymydVJyo3lL2DMT0dsWMzimYILQH4vAF24VwM0hKxX7nVwqGpGCXwBwSJGCwR57lqDiI4RVhKTVJpu7FySfu+Hm9JWSk4fzPXQO/FRqIS5TJQWJSywjLmGwyYtTGsmHTSCwvPFg+0GcG/EkYjPesMc/ycxPixibrEId9Wz03QnLsHYzSBCnPqg8xq8WKYDX2x3dHV3GNsB4TEfVz4psynddDEpX/VhIk2e8cXQ0EoXKkWdJEJB4KFmqj39OhNevCBkF5ADvzFp73J0IxnjOf1AQA==",
      holder: {
        fullname: "Integração Moip",
        birthdate: "1988-12-30",
        taxDocument: {
          type: "CPF",
          number: "33333333333",
        },
        phone: {
          countryCode: "55",
          areaCode: "11",
          number: "000000000",
        },
      },
    },
  })

# TIP: To get your application synchronized to Moip's platform,
# you should have a route that handles Webhooks.
# For further information on the possible webhooks, please refer to the official docs
# (https://dev.moip.com.br/v2.0/reference#lista-de-webhooks-disponíveis)
