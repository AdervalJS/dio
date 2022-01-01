let order = []
let clickedOrder = []
let score = 0

// red => 0
// green => 1
// yellow => 2
// blue => 3

const red = document.getElementById('red')
const green = document.getElementById('green')
const yellow = document.getElementById('yellow')
const blue = document.getElementById('blue')
const genius = document.getElementById('genius')
const clickedTotal = document.querySelector('h1')

// eventos de click das cores
red.addEventListener('click', () => click(0), false)
green.addEventListener('click', () => click(1), false)
yellow.addEventListener('click', () => click(2), false)
blue.addEventListener('click', () => click(3), false)

let getColorElement = (color) => {
    if(color === 0) {
        return red
    } else if(color === 1) {
        return green
    } else if(color === 2) {
        return yellow
    } else if(color === 3){
        return blue
    } 
}

// cria uma ordem aleátoria de cores
let shuffleOrder = async () => {
    let colorOrder = Math.floor(Math.random() * 4)
    order.push(colorOrder)
    clickedOrder = []

    for(i in order ){
        let elementColor = getColorElement(order[i])
        await lightColor(elementColor, Number(i) + 1)
    }
}

// expande a proxima cor
let lightColor = async (elementColor, index) => {
    let time = index * 1300
    let startDelay = time - 180

    await setTimeout(() => {
        elementColor.classList.add('selected')
    }, startDelay)
    
    await setTimeout(() => {
        elementColor.classList.remove('selected')
    }, time)
}

// verifica se os butoes clicados são o mesmos da onden gerada no jogo
let checkOrder = () => {
    for(i in clickedOrder){
        if(clickedOrder[i] !== order[i]) {
            gameOver()
            break
        }
    }

    if(clickedOrder.length === order.length && clickedOrder.length > 0 && order.length > 0){
        win()
    }
}

// funcao para click do usuario
let click = (color) => {
    clickedOrder.push(color)
    getColorElement(color).classList.add('selected')

    setTimeout(() => {
        getColorElement(color).classList.remove('selected')
        checkOrder()
    }, 150)
}

let nextLevel = () => {
    score++
    clickedTotal.textContent = score
    shuffleOrder()
}

let win = async () => {
    genius.classList.add('win')

    await setTimeout(() => {
        genius.classList.remove('win')
        nextLevel()
    }, 1500)
}

let gameOver = async () => {
    genius.classList.add('lose')

    order = []
    clickedOrder = []

    await setTimeout(() => {
        genius.classList.remove('lose')
        playGame()
    }, 1500)
}


let playGame = () => {
    score = 0
    clickedTotal.textContent = score
    shuffleOrder()
}

playGame()