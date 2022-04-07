import * as http from '@/utils/request'

export const captcha = params => http.get('/captcha', params)
export const login = data => http.post('/session', data)
export const reg = data => http.post('/accounts', data)
export const groupMenu = data => http.get('/projects/group', data)
export const logout = data => http.dd('/session', data)
