//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ApiClient {
  ApiClient({this.basePath = 'http://localhost', this.authentication,});

  final String basePath;
  final Authentication? authentication;

  var _client = Client();
  final _defaultHeaderMap = <String, String>{};

  /// Returns the current HTTP [Client] instance to use in this class.
  ///
  /// The return value is guaranteed to never be null.
  Client get client => _client;

  /// Requests to use a new HTTP [Client] in this class.
  set client(Client newClient) {
    _client = newClient;
  }

  Map<String, String> get defaultHeaderMap => _defaultHeaderMap;

  void addDefaultHeader(String key, String value) {
     _defaultHeaderMap[key] = value;
  }

  // We don't use a Map<String, String> for queryParams.
  // If collectionFormat is 'multi', a key might appear multiple times.
  Future<Response> invokeAPI(
    String path,
    String method,
    List<QueryParam> queryParams,
    Object? body,
    Map<String, String> headerParams,
    Map<String, String> formParams,
    String? contentType, {
    Future<void>? abortTrigger,
  }) async {
    await authentication?.applyToParams(queryParams, headerParams);

    headerParams.addAll(_defaultHeaderMap);
    if (contentType != null) {
      headerParams['Content-Type'] = contentType;
    }

    final urlEncodedQueryParams = queryParams.map((param) => '$param');
    final queryString = urlEncodedQueryParams.isNotEmpty ? '?${urlEncodedQueryParams.join('&')}' : '';
    final uri = Uri.parse('$basePath$path$queryString');

    try {
      // Special case for uploading a single file which isn't a 'multipart/form-data'.
      if (
        body is MultipartFile && (contentType == null ||
        !contentType.toLowerCase().startsWith('multipart/form-data'))
      ) {
        final request = AbortableStreamedRequest(method, uri, abortTrigger: abortTrigger);
        request.headers.addAll(headerParams);
        request.contentLength = body.length;
        body.finalize().listen(
          request.sink.add,
          onDone: request.sink.close,
          onError: (Object error, StackTrace trace) => request.sink.close(),
          cancelOnError: true,
        );
        final response = await _client.send(request);
        return Response.fromStream(response);
      }

      if (body is MultipartRequest) {
        final request = AbortableMultipartRequest(method, uri, abortTrigger: abortTrigger);
        request.fields.addAll(body.fields);
        request.files.addAll(body.files);
        request.headers.addAll(body.headers);
        request.headers.addAll(headerParams);
        final response = await _client.send(request);
        return Response.fromStream(response);
      }

      final msgBody = contentType == 'application/x-www-form-urlencoded'
        ? formParams
        : await serializeAsync(body);
      final nullableHeaderParams = headerParams.isEmpty ? null : headerParams;

      final request = AbortableRequest(method, uri, abortTrigger: abortTrigger);
      if (nullableHeaderParams != null) {
        request.headers.addAll(nullableHeaderParams);
      }
      if (msgBody is String && msgBody.isNotEmpty) {
        request.body = msgBody;
      } else if (msgBody is List<int> && msgBody.isNotEmpty) {
        request.bodyBytes = msgBody;
      } else if (msgBody is Map<String, String>) {
        request.bodyFields = msgBody;
      }
      final response = await _client.send(request);
      return Response.fromStream(response);
    } on SocketException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'Socket operation failed: $method $path',
        error,
        trace,
      );
    } on TlsException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'TLS/SSL communication failed: $method $path',
        error,
        trace,
      );
    } on IOException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'I/O operation failed: $method $path',
        error,
        trace,
      );
    } on ClientException catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'HTTP connection failed: $method $path',
        error,
        trace,
      );
    } on Exception catch (error, trace) {
      throw ApiException.withInner(
        HttpStatus.badRequest,
        'Exception occurred: $method $path',
        error,
        trace,
      );
    }
  }

  Future<dynamic> deserializeAsync(String value, String targetType, {bool growable = false,}) async =>
    deserialize(value, targetType, growable: growable);

  @Deprecated('Scheduled for removal in OpenAPI Generator 6.x. Use deserializeAsync() instead.')
  dynamic deserialize(String value, String targetType, {bool growable = false,}) {
    // Remove all spaces. Necessary for regular expressions as well.
    targetType = targetType.replaceAll(' ', '');

    // If the expected target type is String, nothing to do...
    return targetType == 'String'
      ? value
      : fromJson(json.decode(value), targetType, growable: growable);
  }

  Future<String> serializeAsync(Object? value) async => serialize(value);

  @Deprecated('Scheduled for removal in OpenAPI Generator 6.x. Use serializeAsync() instead.')
  String serialize(Object? value) => value == null ? '' : json.encode(value);

  /// Returns a native instance of an OpenAPI class matching the [specified type][targetType].
  static dynamic fromJson(dynamic value, String targetType, {bool growable = false,}) {
    try {
      switch (targetType) {
        case 'String':
          return value is String ? value : value.toString();
        case 'int':
          return value is int ? value : int.parse('$value');
        case 'double':
          return value is double ? value : double.parse('$value');
        case 'bool':
          if (value is bool) {
            return value;
          }
          final valueString = '$value'.toLowerCase();
          return valueString == 'true' || valueString == '1';
        case 'DateTime':
          return value is DateTime ? value : DateTime.tryParse(value);
        case 'AccessRecoveryRequest':
          return AccessRecoveryRequest.fromJson(value);
        case 'AddressResponse':
          return AddressResponse.fromJson(value);
        case 'AppealBody':
          return AppealBody.fromJson(value);
        case 'AppealResult':
          return AppealResult.fromJson(value);
        case 'Appointment':
          return Appointment.fromJson(value);
        case 'AppointmentPlace':
          return AppointmentPlace.fromJson(value);
        case 'ArrivalBody':
          return ArrivalBody.fromJson(value);
        case 'AutocompleteResponse':
          return AutocompleteResponse.fromJson(value);
        case 'AvailabilityBody':
          return AvailabilityBody.fromJson(value);
        case 'AvailabilityResponse':
          return AvailabilityResponse.fromJson(value);
        case 'BlockedPage':
          return BlockedPage.fromJson(value);
        case 'BlockedPerson':
          return BlockedPerson.fromJson(value);
        case 'BusquedaInterpretacion':
          return BusquedaInterpretacion.fromJson(value);
        case 'BusquedaItem':
          return BusquedaItem.fromJson(value);
        case 'BusquedaOficio':
          return BusquedaOficio.fromJson(value);
        case 'BusquedaResponse':
          return BusquedaResponse.fromJson(value);
        case 'ChooseQuoteBody':
          return ChooseQuoteBody.fromJson(value);
        case 'ChosenTechnician':
          return ChosenTechnician.fromJson(value);
        case 'ConfirmPhoneChangeRequest':
          return ConfirmPhoneChangeRequest.fromJson(value);
        case 'ConsentResponse':
          return ConsentResponse.fromJson(value);
        case 'CoverageResponse':
          return CoverageResponse.fromJson(value);
        case 'CreateAddressRequest':
          return CreateAddressRequest.fromJson(value);
        case 'CreateItemRequest':
          return CreateItemRequest.fromJson(value);
        case 'CreateReportBody':
          return CreateReportBody.fromJson(value);
        case 'CreateRequestBody':
          return CreateRequestBody.fromJson(value);
        case 'CreateVerificationRequest':
          return CreateVerificationRequest.fromJson(value);
        case 'CursorPageOfHistoryEntryResponse':
          return CursorPageOfHistoryEntryResponse.fromJson(value);
        case 'CursorPageOfHistoryItemResponse':
          return CursorPageOfHistoryItemResponse.fromJson(value);
        case 'DayScheduleDto':
          return DayScheduleDto.fromJson(value);
        case 'DeleteAccountRequest':
          return DeleteAccountRequest.fromJson(value);
        case 'DeletionScheduledResponse':
          return DeletionScheduledResponse.fromJson(value);
        case 'FirebaseExchangeRequest':
          return FirebaseExchangeRequest.fromJson(value);
        case 'HistoryEntryResponse':
          return HistoryEntryResponse.fromJson(value);
        case 'HistoryItemResponse':
          return HistoryItemResponse.fromJson(value);
        case 'InboxItem':
          return InboxItem.fromJson(value);
        case 'InboxNeighborhood':
          return InboxNeighborhood.fromJson(value);
        case 'InboxResponse':
          return InboxResponse.fromJson(value);
        case 'ItemResponse':
          return ItemResponse.fromJson(value);
        case 'MyQuote':
          return MyQuote.fromJson(value);
        case 'MyQuotePage':
          return MyQuotePage.fromJson(value);
        case 'NeighborhoodAtPointColoniaResponse':
          return NeighborhoodAtPointColoniaResponse.fromJson(value);
        case 'NeighborhoodAtPointResponse':
          return NeighborhoodAtPointResponse.fromJson(value);
        case 'NeighborhoodExistsResponse':
          return NeighborhoodExistsResponse.fromJson(value);
        case 'OficioResponse':
          return OficioResponse.fromJson(value);
        case 'PanelAccesoResponse':
          return PanelAccesoResponse.fromJson(value);
        case 'PanelActivacionRequest':
          return PanelActivacionRequest.fromJson(value);
        case 'PanelActivacionResponse':
          return PanelActivacionResponse.fromJson(value);
        case 'PanelCelularRequest':
          return PanelCelularRequest.fromJson(value);
        case 'PanelCelularResponse':
          return PanelCelularResponse.fromJson(value);
        case 'PanelTotpRequest':
          return PanelTotpRequest.fromJson(value);
        case 'PendingGroupResponse':
          return PendingGroupResponse.fromJson(value);
        case 'PendingResponse':
          return PendingResponse.fromJson(value);
        case 'PermisoConversacion':
          return PermisoConversacion.fromJson(value);
        case 'PhoneAvailabilityRequest':
          return PhoneAvailabilityRequest.fromJson(value);
        case 'ProblemDetails':
          return ProblemDetails.fromJson(value);
        case 'ProfileResponse':
          return ProfileResponse.fromJson(value);
        case 'QuoteComparison':
          return QuoteComparison.fromJson(value);
        case 'QuoteComparisonItem':
          return QuoteComparisonItem.fromJson(value);
        case 'QuoteRequest':
          return QuoteRequest.fromJson(value);
        case 'QuoteResponse':
          return QuoteResponse.fromJson(value);
        case 'QuoteTechnician':
          return QuoteTechnician.fromJson(value);
        case 'RefreshRequest':
          return RefreshRequest.fromJson(value);
        case 'RefreshResponse':
          return RefreshResponse.fromJson(value);
        case 'RegisterTechnicianBody':
          return RegisterTechnicianBody.fromJson(value);
        case 'ReportCreated':
          return ReportCreated.fromJson(value);
        case 'ReportPage':
          return ReportPage.fromJson(value);
        case 'ReportReferenceBody':
          return ReportReferenceBody.fromJson(value);
        case 'ReportSummary':
          return ReportSummary.fromJson(value);
        case 'RequestNeighborhood':
          return RequestNeighborhood.fromJson(value);
        case 'RequestPage':
          return RequestPage.fromJson(value);
        case 'RequestPhoto':
          return RequestPhoto.fromJson(value);
        case 'RequestResponse':
          return RequestResponse.fromJson(value);
        case 'RequestSummary':
          return RequestSummary.fromJson(value);
        case 'RequestTrade':
          return RequestTrade.fromJson(value);
        case 'ScheduleBody':
          return ScheduleBody.fromJson(value);
        case 'SessionListItemResponse':
          return SessionListItemResponse.fromJson(value);
        case 'SessionResponse':
          return SessionResponse.fromJson(value);
        case 'Suggestion':
          return Suggestion.fromJson(value);
        case 'TechnicianProfileBody':
          return TechnicianProfileBody.fromJson(value);
        case 'TechnicianProfileDetail':
          return TechnicianProfileDetail.fromJson(value);
        case 'TechnicianProfileResponse':
          return TechnicianProfileResponse.fromJson(value);
        case 'TechnicianResponse':
          return TechnicianResponse.fromJson(value);
        case 'TecnicoPublicoConversacion':
          return TecnicoPublicoConversacion.fromJson(value);
        case 'TimeRangeDto':
          return TimeRangeDto.fromJson(value);
        case 'TrabajoClient':
          return TrabajoClient.fromJson(value);
        case 'TrabajoFinishedItem':
          return TrabajoFinishedItem.fromJson(value);
        case 'TrabajoFinishedPage':
          return TrabajoFinishedPage.fromJson(value);
        case 'TrabajoPlace':
          return TrabajoPlace.fromJson(value);
        case 'TrabajoQuoteResponse':
          return TrabajoQuoteResponse.fromJson(value);
        case 'TrabajoResponse':
          return TrabajoResponse.fromJson(value);
        case 'TrabajoSummary':
          return TrabajoSummary.fromJson(value);
        case 'TrabajoVerificationResponse':
          return TrabajoVerificationResponse.fromJson(value);
        case 'TrabajoVisitResponse':
          return TrabajoVisitResponse.fromJson(value);
        case 'TrustNotice':
          return TrustNotice.fromJson(value);
        case 'TrustedTechnician':
          return TrustedTechnician.fromJson(value);
        case 'TrustedTechnicianPage':
          return TrustedTechnicianPage.fromJson(value);
        case 'UpdateAddressRequest':
          return UpdateAddressRequest.fromJson(value);
        case 'UpdateConsentRequest':
          return UpdateConsentRequest.fromJson(value);
        case 'UpdateItemRequest':
          return UpdateItemRequest.fromJson(value);
        case 'UpdateProfileRequest':
          return UpdateProfileRequest.fromJson(value);
        case 'UpdateTechnicianBody':
          return UpdateTechnicianBody.fromJson(value);
        case 'ValidationProblemDetails':
          return ValidationProblemDetails.fromJson(value);
        case 'VerificationCreatedResponse':
          return VerificationCreatedResponse.fromJson(value);
        case 'VerificationPhotoResponse':
          return VerificationPhotoResponse.fromJson(value);
        case 'VerificationPhotoStateResponse':
          return VerificationPhotoStateResponse.fromJson(value);
        case 'VerificationStatusResponse':
          return VerificationStatusResponse.fromJson(value);
        case 'VisitCustomer':
          return VisitCustomer.fromJson(value);
        case 'VisitPlace':
          return VisitPlace.fromJson(value);
        case 'VisitResponse':
          return VisitResponse.fromJson(value);
        case 'VisitTechnician':
          return VisitTechnician.fromJson(value);
        case 'WaitlistRequest':
          return WaitlistRequest.fromJson(value);
        case 'WaitlistResponse':
          return WaitlistResponse.fromJson(value);
        case 'ZonaColoniaResponse':
          return ZonaColoniaResponse.fromJson(value);
        case 'ZonaResponse':
          return ZonaResponse.fromJson(value);
        default:
          dynamic match;
          if (value is List && (match = _regList.firstMatch(targetType)?.group(1)) != null) {
            return value
              .map<dynamic>((dynamic v) => fromJson(v, match, growable: growable,))
              .toList(growable: growable);
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)?.group(1)) != null) {
            return value
              .map<dynamic>((dynamic v) => fromJson(v, match, growable: growable,))
              .toSet();
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)?.group(1)) != null) {
            return Map<String, dynamic>.fromIterables(
              value.keys.cast<String>(),
              value.values.map<dynamic>((dynamic v) => fromJson(v, match, growable: growable,)),
            );
          }
      }
    } on Exception catch (error, trace) {
      throw ApiException.withInner(HttpStatus.internalServerError, 'Exception during deserialization.', error, trace,);
    }
    throw ApiException(HttpStatus.internalServerError, 'Could not find a suitable class for deserialization',);
  }
}

/// Primarily intended for use in an isolate.
class DeserializationMessage {
  const DeserializationMessage({
    required this.json,
    required this.targetType,
    this.growable = false,
  });

  /// The JSON value to deserialize.
  final String json;

  /// Target type to deserialize to.
  final String targetType;

  /// Whether to make deserialized lists or maps growable.
  final bool growable;
}

/// Primarily intended for use in an isolate.
Future<dynamic> decodeAsync(DeserializationMessage message) async {
  // Remove all spaces. Necessary for regular expressions as well.
  final targetType = message.targetType.replaceAll(' ', '');

  // If the expected target type is String, nothing to do...
  return targetType == 'String'
    ? message.json
    : json.decode(message.json);
}

/// Primarily intended for use in an isolate.
Future<dynamic> deserializeAsync(DeserializationMessage message) async {
  // Remove all spaces. Necessary for regular expressions as well.
  final targetType = message.targetType.replaceAll(' ', '');

  // If the expected target type is String, nothing to do...
  return targetType == 'String'
    ? message.json
    : ApiClient.fromJson(
        json.decode(message.json),
        targetType,
        growable: message.growable,
      );
}

/// Primarily intended for use in an isolate.
Future<String> serializeAsync(Object? value) async => value == null ? '' : json.encode(value);
