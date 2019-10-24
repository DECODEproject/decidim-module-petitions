# frozen_string_literal: true

require "open3"

module Decidim
  module Petitions
    module Decode
      class Zenroom
        extend Decidim::Petitions::Decode::FileLogger

        CONTRACTS_DIR = "#{File.dirname(__FILE__)}/dddc-pilot-contracts"
        ZENROOM = Gem.bin_path("decidim-petitions")

        def self.hashing(data)
          # Hashes with zenroom some data. For having better privacy with Credential Issuer.
          #
          `echo "print(ECDH.kdf(HASH.new('sha512'), str('#{data}')))" | #{ZENROOM} 2> /dev/null`.strip
        end

        def self.write_to_tmp_file(filename, contents)
          filepath = "#{Rails.root.join("tmp")}/#{filename}"
          f = File.new(filepath, "w")
          f << contents
          f.close
          filepath
        end

        def self.count_petition(json_tally: "", json_petition: "")
          # Counts the petition given a tally.json and petition.json with the contract
          # from DECODE's dddc-pilot-contracts.
          #
          # It shouldn't be the same tally / petition for all the petitions
          contract = "#{CONTRACTS_DIR}/count_petition.zen"
          tally_file_path = write_to_tmp_file("tally.json", JSON.unparse(json_tally))
          petition_file_path = write_to_tmp_file("petition.json", JSON.unparse(json_petition))
          logger("*" * 80)
          logger "ASSERT COUNT WITH ZENROOM"
          logger "TALLY    => #{json_tally}"
          logger "PETITION => #{json_petition}"
          stdout = `#{ZENROOM} -k #{tally_file_path}  -a #{petition_file_path} -z #{contract}`.strip
          stderr = `#{ZENROOM} -k #{tally_file_path}  -a #{petition_file_path} -z #{contract} 2>&1`.strip
          status_code = $?.exitstatus.zero? ? 200 : 100
          {
            stdout: stdout,
            stderr: stderr,
            status_code: status_code,
            data: { tally: json_tally, petition: json_petition }
          }
        end
      end
    end
  end
end
