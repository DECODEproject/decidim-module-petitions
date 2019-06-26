# frozen_string_literal: true

require "spec_helper"

describe "Admin manages petitions", type: :system do
  let(:manifest_name) { "petitions" }
  let!(:petition) { create :petition, component: current_component }

  include_context "when managing a component as an admin"

  it_behaves_like "manage petitions"
end
