//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


library openapi.api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'api_client.dart';
part 'api_helper.dart';
part 'api_exception.dart';
part 'auth/authentication.dart';
part 'auth/api_key_auth.dart';
part 'auth/oauth.dart';
part 'auth/http_basic_auth.dart';
part 'auth/http_bearer_auth.dart';

part 'api/arrival_api.dart';
part 'api/auth_api.dart';
part 'api/choose_quote_api.dart';
part 'api/colonia_exists_api.dart';
part 'api/colonias_api.dart';
part 'api/cotizaciones_api.dart';
part 'api/knock_identity_api_api.dart';
part 'api/lista_espera_api.dart';
part 'api/logout_api.dart';
part 'api/me_api.dart';
part 'api/me_sesiones_api.dart';
part 'api/oficios_api.dart';
part 'api/quote_comparison_api.dart';
part 'api/refresh_api.dart';
part 'api/solicitudes_api.dart';
part 'api/trust_notice_api.dart';
part 'api/visitas_api.dart';
part 'api/zonas_api.dart';

part 'model/appointment.dart';
part 'model/appointment_place.dart';
part 'model/arrival_body.dart';
part 'model/choose_quote_body.dart';
part 'model/chosen_technician.dart';
part 'model/create_request_body.dart';
part 'model/firebase_exchange_request.dart';
part 'model/neighborhood_at_point_colonia_response.dart';
part 'model/neighborhood_at_point_response.dart';
part 'model/neighborhood_exists_response.dart';
part 'model/oficio_response.dart';
part 'model/problem_details.dart';
part 'model/profile_response.dart';
part 'model/quote_comparison.dart';
part 'model/quote_comparison_item.dart';
part 'model/quote_request.dart';
part 'model/quote_response.dart';
part 'model/quote_technician.dart';
part 'model/refresh_request.dart';
part 'model/refresh_response.dart';
part 'model/request_neighborhood.dart';
part 'model/request_page.dart';
part 'model/request_photo.dart';
part 'model/request_response.dart';
part 'model/request_summary.dart';
part 'model/request_trade.dart';
part 'model/session_list_item_response.dart';
part 'model/session_response.dart';
part 'model/trust_notice.dart';
part 'model/update_profile_request.dart';
part 'model/validation_problem_details.dart';
part 'model/visit_customer.dart';
part 'model/visit_place.dart';
part 'model/visit_response.dart';
part 'model/visit_technician.dart';
part 'model/waitlist_request.dart';
part 'model/waitlist_response.dart';
part 'model/zona_colonia_response.dart';
part 'model/zona_response.dart';


/// An [ApiClient] instance that uses the default values obtained from
/// the OpenAPI specification file.
var defaultApiClient = ApiClient();

const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
const _deepEquality = DeepCollectionEquality();
final _dateFormatter = DateFormat('yyyy-MM-dd');
final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

bool _isEpochMarker(String? pattern) => pattern == _dateEpochMarker || pattern == '/$_dateEpochMarker/';
