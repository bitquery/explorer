module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :session_id
    
    def connect
      self.session_id = request.session.id || SecureRandom.uuid
      logger.add_tags 'ActionCable', session_id
    end
    
    def session
      @session ||= request.session
    end
  end
end
