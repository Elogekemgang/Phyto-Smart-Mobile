/*import 'package:dio/dio.dart';

final dio = Dio();

// On ajoute l'intercepteur
dio.interceptors.add(
InterceptorsWrapper(
onRequest: (options, handler) {
// Middleware : avant d'envoyer la requête
// Ex: Ajouter le token d'authentification automatiquement
options.headers["Authorization"] = "Bearer mon_token";
return handler.next(options);
},
onResponse: (response, handler) {
// Middleware : à la réception de la réponse
return handler.next(response);
},
onError: (DioException e, handler) {
// LE MIDDLEWARE MAGIQUE POUR LES ERREURS
if (e.response?.statusCode == 401) {
print("Token expiré, déconnexion forcée !");
// Rediriger vers la page de login ici
} else if (e.response?.statusCode == 500) {
print("Erreur serveur, réessayez plus tard");
}
return handler.next(e);
},
),
);*/