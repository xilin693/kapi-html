import * as http from '@/utils/request'

export const userinfo = (params) => http.get('/userInfo', params)
export const getNameList = (params) => http.get('/accounts/name', params)
export const getAuditList = (params) => http.get('/accounts/audit', params)
export const updateAccount = (params) => http.put('/accounts/' + params.id + '/audit', params)
export const delSession = data => http.dd('/session', data)
export const updatePassword = (params) => http.put('/accounts/password', params)
