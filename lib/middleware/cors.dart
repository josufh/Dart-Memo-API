import 'package:shelf/shelf.dart';

const Map<String, String> _corsHeaders = <String, String>{
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers':
      'X-API-Key, Authorization, Content-Type, Accept',
};

Middleware corsMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response(204, headers: _corsHeaders);
      }

      final Response response = await innerHandler(request);
      return response.change(
        headers: <String, String>{...response.headers, ..._corsHeaders},
      );
    };
  };
}
