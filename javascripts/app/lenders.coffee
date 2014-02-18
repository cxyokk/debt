lenders = [
  {
    name: 'AlberBoy'
    amount: 2300
    paid: true
    returned: true
    hometown: 'gd'
    college: 'bupt'
    greatness: 'great'
  }
  {
    name: 'AlberGirl'
    amount: 1500
    paid: true
    returned: true
    hometown: 'gd'
    college: 'bupt'
    greatness: 'great'
  }
  {
    name: 'Rain'
    amount: 1500
    paid: true
    returned: true
    hometown: 'ah'
    college: 'bupt'
    greatness: 'ordinary'
  }
  {
    name: 'Slim'
    amount: 1000
    paid: true
    returned: true
    hometown: 'cq'
    college: 'bit'
    greatness: 'soccer'
  }
  {
    name: 'Crazy'
    amount: 500
    paid: true
    returned: true
    hometown: 'gd'
    college: 'sysu'
    greatness: 'hedgehog'
  }
  {
    name: 'OShell'
    amount: 500
    paid: true
    returned: true
    hometown: 'zj'
    college: 'bit'
    greatness: 'slag'
  }
  {
    name: 'Volcano'
    amount: 500
    paid: true
    returned: true
    hometown: 'gd'
    college: 'sysu'
    greatness: 'science'
  }
]

lenders = _.shuffle lenders

window.debtApp ?= { }
window.debtApp.lenders = lenders
