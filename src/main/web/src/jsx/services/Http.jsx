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

    makeConfig(url, method, body) {
        console.log('request', method, url);
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

    async checkError(response) {
        console.log('Response:', response);
        if (response.status >= 200 && response.status <= 299) {
            return response.json();
        } else {
            const errorText = await response.text();
            throw Error(JSON.stringify({status: response.status, text: errorText}));
        }
    }

    catch401(url, error) {
        console.log('Http:', error.message);
        const errorObject = JSON.parse(error.message);
        if (url.indexOf('/Login') === -1 && errorObject.status === 401) {
            location.href = window.origin + '/login-screen';
            return;
        }
        throw error;
    }

    addJsonHeaders(config) {
        if (!config.headers) {
            config.headers = {};
        }

        config.headers['Accept'] = 'application/json';
        config.headers['Content-Type'] = 'application/json';

    }

    addAuthenticateRequest(url, config) {

        if (url.indexOf("/Login") !== -1 && url.indexOf("/config") !== -1 && url.indexOf("/SignUp") !== -1) {
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