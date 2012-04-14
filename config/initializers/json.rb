require 'json'
module JSON
  class << self
    def is_json?(string)
      begin
        JSON.parse(string).all?
      rescue ParserError
        false
      end
    end

    def test_autoload
      true
    end
  end
end

