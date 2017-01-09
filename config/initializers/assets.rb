# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( DisplayTimer.js )
Rails.application.config.assets.precompile += %w( advocate.css )
Rails.application.config.assets.precompile += %w( enquirer.css )
Rails.application.config.assets.precompile += %w( gazette.css )
Rails.application.config.assets.precompile += %w( herald.css )
Rails.application.config.assets.precompile += %w( intel.css )
Rails.application.config.assets.precompile += %w( journal.css )
Rails.application.config.assets.precompile += %w( peoplef.css )
Rails.application.config.assets.precompile += %w( peopleg.css )
Rails.application.config.assets.precompile += %w( peoples.css )
Rails.application.config.assets.precompile += %w( review.css )
Rails.application.config.assets.precompile += %w( spokeo.css )
Rails.application.config.assets.precompile += %w( times.css )
Rails.application.config.assets.precompile += %w( tribune.css )
Rails.application.config.assets.precompile += %w( ussearch.css )
Rails.application.config.assets.precompile += %w( white.css )
Rails.application.config.assets.precompile += %w( zoom.css )
