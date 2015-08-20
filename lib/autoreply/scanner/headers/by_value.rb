module Autoreply
  class Scanner::Headers::ByValue < Scanner::Headers::Base
    KNOWN_HEADERS = {
      "x-spam-flag" => /yes/,
      "x-spam-status" => /yes/,
      "x-spam-flag2" => /yes/,
      "precedence" => /(bulk|list|junk)/,
      "x-precedence" => /(bulk|list|junk)/,
      "x-barracuda-spam-status" => /yes/,
      "x-dspam-result" => /(spam|bl[ao]cklisted)/,
      "x-mailer" => /^[mM]ail$/,
      "auto-submitted" => /auto-replied/,
      "x-autogenerated" => /reply/,
      "x-autosubmitted" => /(?!no)/
    }

    def autoreply?
      !detected_headers.blank?
    end

    private

      def detected_headers
        header_fields.inject([]) do |result, incoming_header|
          name  = incoming_header.name.downcase
          value = incoming_header.value

          KNOWN_HEADERS.each do |header_name, regexp|
            if name == header_name && value =~ regexp
              result.push(name)
            end
          end

          result
        end
      end
  end
end