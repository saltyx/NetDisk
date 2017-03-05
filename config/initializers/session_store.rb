


#Rails.application.config.session_store :redis_store, servers: 'redis://localhost:6379/0/session'
NetDisk::Application.config.session_store :redis_store, servers: "redis://localhost:6379/0/session"