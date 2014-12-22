module JazzHands
  class Railtie < Rails::Railtie
    initializer 'jazz_hands.initialize' do |app|
      JazzHands.initialize!({name: app.class.parent_name.underscore})
    end
  end
end
