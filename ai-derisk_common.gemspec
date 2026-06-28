# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'ai-derisk_common'
  spec.version     = '0.1.0'
  spec.authors     = ['DeriskLabs']
  spec.email       = ['engineering@derisklabs.com']

  spec.summary     = 'Common workflow and knowledge-structure skills for AI coding agents.'
  spec.description = 'The derisk_common skill collection: SKILL.md documents defining ' \
                     'agent behaviour such as commit policy and portable OKF bundle ' \
                     'maintenance. Data-only gem; nothing to require.'
  spec.homepage    = 'https://github.com/DeriskLabs/AI-derisk_common'
  spec.license     = 'MIT'

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'rubygems_mfa_required' => 'true',
  }

  spec.files = Dir['INDEX.md', 'GEMINI.md', 'LICENSE.txt', '*/**/*'].select { |f| File.file?(f) }

  spec.require_paths = ['.']
end
