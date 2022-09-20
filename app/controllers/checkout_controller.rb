class CheckoutController < ApplicationController

    before_action :allow_cross_domain_access
    after_action :cors_set_access_control_headers
    
    def allow_cross_domain_access
        headers['Access-Control-Allow-Origin'] = '*'# http://localhost:9000
        headers['Access-Control-Allow-Headers'] = '*'
        headers['Access-Control-Allow-Methods'] = '*'
        headers['Access-Control-Allow-Credentials'] = 'true'
        headers['Access-Control-Max-Age'] = '1728000'
    end
    def cors_set_access_control_headers
            headers['Access-Control-Allow-Origin'] = '*'
            headers['Access-Control-Allow-Methods'] = '*'
            headers['Access-Control-Allow-Headers'] = '*'
            headers['Access-Control-Allow-Credentials'] = 'true'
            headers['Access-Control-Max-Age'] = "1728000"
    end

    def create 
        product = Product.find(params[:id])
        @session = Stripe::Checkout::Session.create({
            customer: current_user.stripe_customer_id,
            payment_method_types: ['card'],
            line_items: [{
                price_data: {
                    currency: 'usd',
                    unit_amount: product.price,
                    product_data: {
                      name: product.name,
                      description: product.description,
                    },
                },
                quantity: 1,

            }],
            mode: 'payment',
            success_url: root_url + "?session_id={CHECKOUT_SESSION_ID}",
            cancel_url: root_url,
        })
        
        redirect_to @session.url, allow_other_host: true
      
        end
        

end
