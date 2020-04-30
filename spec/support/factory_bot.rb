RSpec.configure do |config|
  config.before :all do
    FactoryBot.reload
  end

  config.include FactoryBot::Syntax::Methods
end
