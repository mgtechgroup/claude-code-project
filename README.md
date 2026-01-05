# Project with Claude Code Action

This repository is configured with the Claude Code Action for automated code assistance on pull requests.

## Setup

The Claude Code Action is configured in `.github/workflows/claude-code.yml` and will automatically:
- Respond to pull request comments
- Help with code reviews
- Assist with development tasks

## How to Use

To interact with Claude Code Action on a pull request:
1. Create a pull request with your changes
2. Comment on the PR with requests like:
   - `@claude-code help me review this code`
   - `@claude-code suggest improvements`
   - `@claude-code explain this change`
3. Claude will automatically respond with assistance

## Testing

This is a test pull request to verify the Claude Code Action setup is working correctly.

For more information, see: https://github.com/anthropics/claude-code-action
