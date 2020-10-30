const API_ROOT = process.env.NODE_ENV === 'dev' ? 'http://' + window.location.hostname + ':8080' : '';
const API_URL = API_ROOT + '/API';

export const API = {
    CATEGORY: {
        ALL: API_URL + '/Category',
        AVAILABLE: API_URL + '/Category/Available',
        ADD: API_URL + '/Category',
        GET: API_URL + '/Category/ById/{0}',
        UPDATE_ALL: API_URL + '/Category',
        DELETE: API_URL + '/Category/{0}',
        SEARCH: API_URL + '/Category/search-icon',
    },
    EXPENSE: {
        ADD: API_URL + '/Expense',
        BY_MONTH: API_URL + '/Expense/ByDay?month={0}',
        GET_MONTHS: API_URL + '/Expense/GetMonths',
        DELETE: API_URL + '/Expense/{0}',
    },
    HISTORY: {
        OVERALL: {
            MONTH: API_URL + "/History/CurrentMonth",
            YEAR: API_URL + "/History/CurrentYear",
        },
        YEARLY: API_URL + "/History/Yearly/{0}/{1}",
        MONTHLY: API_URL + "/History/Monthly/{0}/{1}",
    },
    RECURRING: {
        GET: API_URL + '/RecurringExpense',
        ADD: API_URL + '/RecurringExpense',
        DELETE: API_URL + '/RecurringExpense/{0}'
    },
    SESSION: {
        LOGIN: API_ROOT + '/Login',
        SIGNUP: API_ROOT + '/SignUp',
        RESET_PASSWORD_REQUEST: API_ROOT + "/ResetPasswordRequest",
        RESET_PASSWORD: API_ROOT + "/ResetPassword",
    },
    SETTINGS: {
        UPDATE: API_URL + '/Setting',
        ALL: API_URL + '/Setting',
        GET: API_URL + '/Setting/{0}',
    },
    MISC: {
        VERSION: API_URL + '/Misc/version',
        GET_CONFIG: API_ROOT + "/config",
    },
    USER: {
        EDIT_PROFILE: API_URL + "/User",
        GET: API_URL + "/User",
        SET_ADMIN: API_URL + "/User/{0}/setAdmin/{1}",
        UPDATE_PASSWORD: API_URL + "/User/{0}/setPassword",
        ADD_USER: API_URL + "/User",
        DELETE_USER: API_URL + "/User/{0}",
    }

};
