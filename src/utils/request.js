import axios from "axios";
import {MessageBox, Message} from "element-ui";
import {getToken, removeToken} from "@/utils/auth";
import QS from "qs";
import MD5 from "md5";

const instance = axios.create()
instance.defaults.baseURL = process.env.VUE_APP_BASE_API
instance.interceptors.request.use(
    config => {
        //showLoading();
        config.headers["Authorization"] = localStorage.getItem("token");
        config.headers["code"] = localStorage.getItem("code");
        return config;
    },
    error => {
        // do something with request error
        return Promise.reject(error);
    }
);

instance.interceptors.response.use(
    response => {
        if (response.status == 200) {
            return response;
        }
    },
    error => {
        if (error.response.status == 401) {
            console.log('token失效');
            location.href = '/#/login';
        } else {
            Message({
                message: error.response.data.msg,
                type: 'error',
                duration: 5 * 1000
            })
            return Promise.reject(error.response);
        }

    }
);

/**
 * get方法，对应get请求
 * @param {String} url [请求的url地址]
 * @param {Object} params [请求时携带的参数]
 */
export function get(url, params) {
    const token = localStorage.getItem('token');
    // if (token) {
    //     params['token'] = localStorage.getItem('token')
    // }
    return new Promise((resolve, reject) => {
        instance
            .get(url, {
                params: params
            })
            .then(res => {
                // store.commit('SET_LOADING', false)
                resolve(res);
            })
            .catch(err => {
                // store.commit('SET_LOADING', false)
                reject(err);
            });
    });
}

export function onInput() {
    this.$forceUpdate()
}


/**
 * post方法，对应post请求
 * @param {String} url [请求的url地址]
 * @param {Object} data  [请求时携带的参数]
 */

export function post(url, data) {
    // data['token'] = localStorage.getItem('token')
    return new Promise((resolve, reject) => {
        const myData = data;
        if (myData.id) {
            delete myData.id;
        }
        instance
            .post(url, QS.stringify(myData))
            .then(res => {
                // store.commit('SET_LOADING', false)
                resolve(res);
            })
            .catch(err => {
                // store.commit('SET_LOADING', false)
                reject(err);
            });
    });
}

export function dd(url, data) {
    return new Promise((resolve, reject) => {
        instance
            .delete(url)
            .then(res => {
                // store.commit('SET_LOADING', false)
                resolve(res);
            })
            .catch(err => {
                // store.commit('SET_LOADING', false)
                reject(err);
            });
    });
}

export function put(url, data = {}) {
    return new Promise((resolve, reject) => {
        const newData = data;
        if (newData.id) {
            delete newData.id;
        }
        instance
            .put(url, newData)
            .then(res => {
                resolve(res);
            })
            .catch(err => {
                reject(err);
            });
    });
}
