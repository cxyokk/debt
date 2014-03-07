lenders = [
  {
    name: 'alber'
    amount: 10000
    paid: true
    returned: false
    hometown: 'gd'
    hobby: 'sorry'
    greatness: 'great'
  }
  {
    name: 'gold'
    amount: 5000
    paid: true
    returned: true
    hometown: 'hb'
    hobby: 'foosball'
    greatness: 'gold'
  }
  {
    name: 'fly'
    amount: 3000
    paid: true
    returned: true
    hometown: 'sx'
    hobby: 'foosball'
    greatness: 'fly'
  }
  {
    name: 'slim'
    amount: 1500
    paid: true
    returned: true
    hometown: 'cq'
    hobby: 'pes'
    greatness: 'soccer'
  }
]

lenders = _.shuffle lenders

window.debtApp ?= { }
window.debtApp.lenders = lenders
