RSpec.configure do |config|
  config.before(:each) do |example|
    # if example.metadata[:type] == :system
    #   driven_by :selenium, screen_size: [1400, 1000]
    # end

    if example.metadata[:type] == :system
      if example.metadata[:js]
        driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1000]
      else
        driven_by :rack_test
      end
    end
  end
end
