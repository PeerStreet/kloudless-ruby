module Kloudless
  # All errors inherit from Kloudless::Error. You may rescue this class as a
  # catch all. Specific errors are documented in
  # https://developers.kloudless.com/docs#errors
  #
  #  begin
  #    # ... some api action
  #  rescue Kloudless::Error => e
  #    $stderr.puts e.status_code  # 401
  #    $stderr.puts e.error_code   # 'unauthorized'
  #    $stderr.puts e.id           # id of request that caused the error
  #    $stderr.puts e.conflicting_resource_id
  #    $stderr.puts e.message
  #  end
  #
  class Error < RuntimeError
    # Public: e.g. 400, 401, 500, 4xx-5xx.
    attr_accessor :status_code

    # Public: short string name of error. e.g. bad_request, request_failed
    attr_accessor :error_code

    # Public: identifier of request that caused the error
    attr_accessor :id

    # Public: identitifer of resource request conflicted with. See 409.
    attr_accessor :conflicting_resource_id

    # Internal: `json` is a Hash. Returns an instantiated subclass of
    # Kloudless::Error.
    def self.from_json(json)
      error_class = ERRORS.fetch(json["error_code"].to_sym, UnknownError)
      error = error_class.new(json["message"])
      error.error_code = json["error_code"]
      error.status_code = json["status_code"]
      error.id = json["id"]
      error.conflicting_resource_id = json["conflicting_resource_id"]
      error
    end
  end

  # 400  The request is malformed. Check the message for the reason.
  class BadRequestError < Error; end

  # 400  The request failed. Check the message for the reason.
  class RequestFailedError < Error; end

  # 400  Invalid parent folder_id parameter.
  class InvalidParentFolderError < Error; end

  # 400  The request is malformed: the parameters are incorrect.
  class InvalidParametersError < Error; end

  # 400  The resource_type provided is not correct.
  class InvalidResourceTypeError < Error; end

  # 401  The Kloudless credentials or token provided are invalid.
  class UnauthorizedError < Error; end

  # 401  The credentials or token provided for the upstream cloud storage
  # service are invalid.
  class ServiceUnauthorizedError < Error; end

  # 401  An authorization parameter is missing.
  class AuthenticationRequiredError < Error; end

  # 401  Invalid request token provided.
  class InvalidTokenError < Error; end

  # 403  Cannot delete the folder as it is not empty and the recursive parameter is not set to True.
  class FolderNotEmptyError < Error; end

  # 403  Unable to access resource.
  class PermissionDeniedError < Error; end

  # 403  Forbidden request made to Kloudless.
  class ForbiddenError < Error; end

  # 403  Forbidden request made to the upstream cloud storage service.
  class ServiceForbiddenError < Error; end

  # 404  The requested resource was not found.
  class NotFoundError < Error; end

  # 405  The request was made using an unsupported method.
  class MethodNotAllowedError < Error; end

  # 406  The request was made with unacceptable data.
  class NotAcceptableError < Error; end

  # 409  Resource already exists. Checking the conflicting_resource_id
  # parameter in the response.
  class NamingConflictError < Error; end

  # 429  Too many requests to the Kloudless API were made. Check the
  # Retry-After header.
  class TooManyRequestsError < Error; end

  # 429  Too many requests to the underlying service API were made. Check the Retry-After header.
  class TooManyServiceRequestsError < Error; end

  # 500  The request was made by Kloudless with an unsupported method.*
  class MethodNotAllowedError < Error; end

  # 500  The request was made by Kloudless with unacceptable data.*
  class NotAcceptableError < Error; end

  # 500  Kloudless experienced an internal error.*
  class InternalErrorError < Error; end

  # 500  Kloudless experienced an error retrieving link data.*
  class LinkErrorError < Error; end

  # 500  Kloudless experienced an error making an invalid request.*
  class UnsupportedMediaTypeError < Error; end

  # 501  The request method is not currently implemented for the cloud storage service.
  class NotImplementedError < Error; end

  # 502  Kloudless received an invalid response from the upstream cloud storage service.
  class BadGatewayError < Error; end

  # 503  The upstream cloud storage service is unavailable.
  class ServiceNotAvailableError < Error; end

  # 504  The upstream cloud storage service is unavailable.
  class GatewayTimeoutError < Error; end

  # 507  There is not enough free space in the cloud storage account to complete the request.
  class InsufficientStorageError < Error; end

  # We should never see this error. This means the API added an error we don't
  # know about.
  class UnknownError < Error; end

  class Error
    # We could use ActiveSupport::Inflector here, but didn't want to bring in a
    # dependency. To regenerate, copy from docs, and run:
    #
    # pbpaste | ruby -r'active_support/core_ext/string/inflections' -ne 'puts "#{$_.chomp}: #{$_.classify.chomp},"'
    ERRORS = {
      bad_request: BadRequestError,
      request_failed: RequestFailedError,
      invalid_parent_folder: InvalidParentFolderError,
      invalid_parameters: InvalidParametersError,
      invalid_resource_type: InvalidResourceTypeError,
      unauthorized: UnauthorizedError,
      service_unauthorized: ServiceUnauthorizedError,
      authentication_required: AuthenticationRequiredError,
      invalid_token: InvalidTokenError,
      folder_not_empty: FolderNotEmptyError,
      permission_denied: PermissionDeniedError,
      forbidden: ForbiddenError,
      service_forbidden: ServiceForbiddenError,
      not_found: NotFoundError,
      naming_conflict: NamingConflictError,
      too_many_requests: TooManyRequestsError,
      too_many_service_requests: TooManyServiceRequestsError,
      internal_error: InternalErrorError,
      link_error: LinkErrorError,
      unsupported_media_type: UnsupportedMediaTypeError,
      not_implemented: NotImplementedError,
      bad_gateway: BadGatewayError,
      service_not_available: ServiceNotAvailableError,
      gateway_timeout: GatewayTimeoutError,
      insufficient_storage: InsufficientStorageError
    }
  end
end
