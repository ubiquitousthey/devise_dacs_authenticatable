# Thrown when a user attempts to pass a DACS ticket that the server
# says is invalid.
class InvalidDacsTicketException < Exception
  attr_reader :ticket
  
  def initialize(ticket, msg=nil)
    super(msg)
    @ticket = ticket
  end
end
