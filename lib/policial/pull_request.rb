# frozen_string_literal: true

module Policial
  # Public: A GitHub Pull Request.
  class PullRequest
    attr_reader :repo, :number, :user
    attr_accessor :github_client

    def initialize(repo:, number:, head_sha:, github_client:, user: nil)
      @repo = repo
      @number = number
      @head_sha = head_sha
      @user = user
      @github_client = github_client
    end

    def files
      @files ||= @github_client.pull_request_files(
        @repo, @number
      ).map do |file|
        build_commit_file(file)
      end
    end

    def head_commit
      @head_commit ||= Commit.new(@repo, @head_sha, @github_client)
    end

    private

    def build_commit_file(file)
      CommitFile.new(file, head_commit)
    end
  end
end
