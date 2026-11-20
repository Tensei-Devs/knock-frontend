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

part 'api/access_recovery_api.dart';
part 'api/arrival_api.dart';
part 'api/auth_api.dart';
part 'api/bloqueos_api.dart';
part 'api/busqueda_api.dart';
part 'api/casa_y_auto_api.dart';
part 'api/choose_quote_api.dart';
part 'api/colonia_exists_api.dart';
part 'api/colonias_api.dart';
part 'api/conversation_permission_api.dart';
part 'api/cotizaciones_api.dart';
part 'api/internal_history_api.dart';
part 'api/knock_identity_api_api.dart';
part 'api/lista_espera_api.dart';
part 'api/logout_api.dart';
part 'api/me_api.dart';
part 'api/me_cambio_numero_api.dart';
part 'api/me_consentimientos_api.dart';
part 'api/me_direcciones_api.dart';
part 'api/me_eliminacion_api.dart';
part 'api/me_exportaciones_api.dart';
part 'api/me_pendientes_api.dart';
part 'api/me_sesiones_api.dart';
part 'api/oficios_api.dart';
part 'api/quote_comparison_api.dart';
part 'api/refresh_api.dart';
part 'api/reportes_api.dart';
part 'api/solicitudes_api.dart';
part 'api/tecnicos_api.dart';
part 'api/tecnicos_me_api.dart';
part 'api/trust_notice_api.dart';
part 'api/trusted_technicians_api.dart';
part 'api/visitas_api.dart';
part 'api/zonas_api.dart';

part 'model/access_recovery_request.dart';
part 'model/address_response.dart';
part 'model/appeal_body.dart';
part 'model/appeal_result.dart';
part 'model/appointment.dart';
part 'model/appointment_place.dart';
part 'model/arrival_body.dart';
part 'model/autocomplete_response.dart';
part 'model/availability_body.dart';
part 'model/availability_response.dart';
part 'model/blocked_page.dart';
part 'model/blocked_person.dart';
part 'model/busqueda_interpretacion.dart';
part 'model/busqueda_item.dart';
part 'model/busqueda_oficio.dart';
part 'model/busqueda_response.dart';
part 'model/choose_quote_body.dart';
part 'model/chosen_technician.dart';
part 'model/confirm_phone_change_request.dart';
part 'model/consent_response.dart';
part 'model/coverage_response.dart';
part 'model/create_address_request.dart';
part 'model/create_item_request.dart';
part 'model/create_report_body.dart';
part 'model/create_request_body.dart';
part 'model/cursor_page_of_history_entry_response.dart';
part 'model/cursor_page_of_history_item_response.dart';
part 'model/day_schedule_dto.dart';
part 'model/delete_account_request.dart';
part 'model/deletion_scheduled_response.dart';
part 'model/firebase_exchange_request.dart';
part 'model/history_entry_response.dart';
part 'model/history_item_response.dart';
part 'model/item_response.dart';
part 'model/neighborhood_at_point_colonia_response.dart';
part 'model/neighborhood_at_point_response.dart';
part 'model/neighborhood_exists_response.dart';
part 'model/oficio_response.dart';
part 'model/pending_group_response.dart';
part 'model/pending_response.dart';
part 'model/permiso_conversacion.dart';
part 'model/phone_availability_request.dart';
part 'model/problem_details.dart';
part 'model/profile_response.dart';
part 'model/quote_comparison.dart';
part 'model/quote_comparison_item.dart';
part 'model/quote_request.dart';
part 'model/quote_response.dart';
part 'model/quote_technician.dart';
part 'model/refresh_request.dart';
part 'model/refresh_response.dart';
part 'model/register_technician_body.dart';
part 'model/report_created.dart';
part 'model/report_page.dart';
part 'model/report_reference_body.dart';
part 'model/report_summary.dart';
part 'model/request_neighborhood.dart';
part 'model/request_page.dart';
part 'model/request_photo.dart';
part 'model/request_response.dart';
part 'model/request_summary.dart';
part 'model/request_trade.dart';
part 'model/schedule_body.dart';
part 'model/session_list_item_response.dart';
part 'model/session_response.dart';
part 'model/suggestion.dart';
part 'model/technician_profile_body.dart';
part 'model/technician_profile_detail.dart';
part 'model/technician_profile_response.dart';
part 'model/technician_response.dart';
part 'model/tecnico_publico_conversacion.dart';
part 'model/time_range_dto.dart';
part 'model/trust_notice.dart';
part 'model/trusted_technician.dart';
part 'model/trusted_technician_page.dart';
part 'model/update_address_request.dart';
part 'model/update_consent_request.dart';
part 'model/update_item_request.dart';
part 'model/update_profile_request.dart';
part 'model/update_technician_body.dart';
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
