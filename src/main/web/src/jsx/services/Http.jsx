class Http {

    get(url) {
        return this.makeRequest('GET', url);

    }

    delete(url) {
        return this.makeRequest('DELETE', url);

    }

    post(url, body) {
        return this.makeRequest('POST', url, body);
    }

    put(url, body) {
        return this.makeRequest('PUT', url, body);
    }

    checkError(response) {
        if (response.status >= 200 && response.status <= 299) {
            return response.json();
        } else {
            throw Error(response.status);
        }
    }

    makeConfig(url, method, body) {

        const config = {
            method: method,
        };

        if (body) {
            config.body = JSON.stringify(body);
        }
        if (url.indexOf("/Login") === -1) {
            if (typeof window.localStorage !== undefined && window.localStorage.token) {
                config.headers = {
                    'Authorization': localStorage.token
                }
            }
        }

        this.addJsonHeaders(config);

        return config;
    }

    makeRequest(method, url, body) {
        const config = this.makeConfig(url, method, body);
        return fetch(url, config).then(this.checkError).catch(e => this.catch401(url, e));
    }

    catch401(url, error) {
        if (url.indexOf('/Login') === -1 && error.message === '401') {
            location.href = window.origin + '/login-screen';
            return;
        }
        return error;
    }

    addJsonHeaders(config) {
        if (!config.headers) {
            config.headers = {};
        }

        config.headers['Accept'] = 'application/json';
        config.headers['Content-Type'] = 'application/json';

    }

    addAuthenticateRequest(url, config) {

        if (url.indexOf("/Login") !== -1) {
            if (typeof window.localStorage !== undefined && window.localStorage.token) {
                return {
                    headers: {
                        'Authorization': localStorage.token
                    }
                }
            }
        }

        return {};
    }

}

export default Http = new Http();