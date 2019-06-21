module Decidim::Petitions
  module Admin::PetitionsHelper
    def jsonify(json)
      JSON.pretty_generate(JSON.parse(json))
    end
  end
end
