const TokenKey = 'token'
const Routes = 'routes'
const DefaultImg = 'defaultImg'
const userId = 'userId'

function clear() {
    localStorage.removeItem(userId)
    localStorage.removeItem(DefaultImg)
    localStorage.removeItem(Routes)
}

export function getToken() {
    return localStorage.getItem(TokenKey)
}

export function setToken(token) {
    return localStorage.setItem(TokenKey, token)
}

export function setRoute(data) {
    return localStorage.setItem(Routes, data)
}

export function getRoute() {
    return localStorage.getItem(Routes)
}

export function removeToken() {
    clear()
    return localStorage.removeItem(TokenKey)
}

export function getGroupName(id) {
    const obj = getRoute()
    const data = JSON.parse(obj)
    for (let i = 0; i < data.length; i++) {
        if (data[i].id == id) {
            return data[i].name
        }
    }
}
