const requireAuth = (request, response, next) => {
    if (request.userId) {
        next();
    } else {
        response.status(401).json({
            errors: {
                main: "Jeton d'authentification manquante ou invalide",
            },
            authStatus: request.authStatus,
        });
    }
};

module.exports = requireAuth;
