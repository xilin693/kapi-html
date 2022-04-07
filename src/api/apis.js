import * as http from '@/utils/request'

export const getProjectApi = (params) => http.get('/apis/' + params.id + '/project')
export const getApi = (params) => http.get('/apis/' + params.id)
export const getApiList = (id, params) => http.get('/apis/' + id + '/list/', params)
export const setApiField = (params) => http.put('/apis/' + params.id + '/field', params)
export const saveApiCategory = (params) => http.post('/apis/category', params)
export const saveApi = (params) => http.post('/apis', params)
export const copyApi = (params) => http.post('/apis/copy', params)
export const delApi = (params) => http.dd('/apis/' + params.id)
export const getCategory = (params) => http.get('/apis/' + params.id + '/category')
export const searchApi = (params) => http.get('/apis/search', params)
export const getApiDetail = (params) => http.get('/apis/' + params.id)
export const saveApiDetail = (params) => http.put('/apis/' + params.id, params)
export const runApi = (params) => http.post('apis/run', params)
export const importJson = (params) => http.post('apis/json', params)
export const getRelativeApi = (id) => http.get('apis/' + id + '/relative')
export const copyRelative = (params) => http.post('apis/relative', params)
export const saveSort = (params) => http.put('apis/sort', params)
export const toQueryString = object =>
    '?' +
    Object.keys(object)
        .map(key => `${key}=${object[key].toString()}`)
        .join('&');

