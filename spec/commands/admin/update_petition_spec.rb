# frozen_string_literal: true

module Decidim::Petitions
  describe Admin::UpdatePetition do
    let(:petition) { create :petition }

    let(:params) do
      {
        petition: {
          id: petition.id,
          title_en: "Foo title",
          title_es: "Foo title",
          title_ca: "Foo title",
          description_en: "Foo description",
          description_es: "Foo description",
          description_ca: "Foo description",
          summary_en: "Foo summary",
          summary_es: "Foo summary",
          summary_ca: "Foo summary",
          image: petition.image,
          json_schema: petition.json_schema,
          json_attribute_info: petition.json_attribute_info,
          json_attribute_info_optional: petition.json_attribute_info
        }
      }
    end

    let(:context) do
      {
        current_organization: petition.organization,
        petition_id: petition.id
      }
    end

    let(:form) { Admin::PetitionForm.from_params(params).with_context(context) }

    let(:command) { described_class.new(petition, form) }

    describe "when the petition form is invalid" do
      before do
        expect(form).to receive(:invalid?).and_return(true)
      end

      it "broadcasts invalid" do
        expect { command.call }.to broadcast(:invalid)
      end
    end

    describe "when the petition is not valid" do
      before do
        expect(form).to receive(:invalid?).and_return(false)
        expect(petition).to receive(:valid?).at_least(:once).and_return(false)
        petition.errors.add(:banner_image, "Image too big")
      end

      it "broadcasts invalid" do
        expect { command.call }.to broadcast(:invalid)
      end
    end

    describe "when the petition is valid" do
      it "broadcast ok" do
        expect { command.call }.to broadcast(:ok)
      end

      it "update the petition" do
        command.call
        petition.reload
        expect(petition.title["en"]).to eq "Foo title"
      end
    end
  end
end
