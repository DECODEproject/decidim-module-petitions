# frozen_string_literal: true

require "spec_helper"

describe Decidim::Petitions::Decode::Zenroom do
  context "when hashing work" do
    it "give the correct hash" do
      result = described_class.hashing("hello world")
      expect(result).to eq "d33c2600e0b033669058e8ef39962bc21db40c2b1884b497df094e96a25aea9ed04c40d6408fc1eb5bc6e9bf131cd7bf117b2e6ae2450db7b7f88202849536de"
    end

    it "give an incorrect hash" do
      result = described_class.hashing("invalid")
      expect(result).not_to eq "d33c2600e0b033669058e8ef39962bc21db40c2b1884b497df094e96a25aea9ed04c40d6408fc1eb5bc6e9bf131cd7bf117b2e6ae2450db7b7f88202849536de"
    end
  end
end
