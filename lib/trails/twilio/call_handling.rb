module Trails
  module Twilio
    module CallHandling
      def self.included( klass )
        raise "can\'t include #{self} in #{klass} - not a Controller?" unless 
          klass.respond_to?( :before_filter )
        Mime::Type.register_alias( "text/html", :twiml ) unless Mime.const_defined?( 'TWIML' )
        klass.send( :prepend_before_filter, :setup_incoming_call )
        klass.send( :attr_reader, :incoming_call )
        klass.send( :alias_method_chain, :protect_against_forgery?, :twilio )
        klass.send( :append_view_path, File.expand_path( File.join( File.dirname( __FILE__ ), 
                                                            '../../../assets' ) ) )
        klass.send( :alias_method_chain, :default_layout, :twilio )
      end

      protected

      def default_layout_with_twilio
        is_twilio_call? ? twiml_layout : default_layout_without_twilio
      end

      def twiml_layout
        'default_layout.twiml.builder'
      end

      def protect_against_forgery_with_twilio?
        is_twilio_call? ? false : protect_against_forgery_without_twilio?
      end

      def setup_incoming_call
        return unless is_twilio_call?
        logger.debug{ "at the beginning, request.params = #{request.parameters}" }
        request.format = :twiml
        response.content_type = 'text/xml'

        @incoming_call = Trails::Twilio::Incoming.new( request )
      end

      # TODO: Move this onto the request object,
      # it makes more sense to say:
      #
      #    request.is_twilio_call?
      #

      #
      # TODO (minch):
      #
      # Add security per:
      #
      # http://www.twilio.com/docs/security-reliability/security
      #
      # Which basically checks the value of request.env['HTTP_X_TWILIO_SIGNATURE']
      #
      # For now we'll simply check that both the above and the correct account sid
      # exist in the request.
      #
      def is_twilio_call?
        # NOTE:  if we force the header check now then it makes it difficult to test w/a browser, not ideal for the beta phase.
        # Therefore, leaving this as a TODO for now.
        return ! Trails::Twilio::Account.sid_from_request( request ).blank? # && request.env['HTTP_X_TWILIO_SIGNATURE'].blank?)
      end

      protected

    end # module CallHandling
  end # module Twilio
end # module Trails
