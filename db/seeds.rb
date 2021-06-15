# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

list1 = List.create(name: 'To Do', position: 0)
list2 = List.create(name: 'In progress', position: 1)
list3 = List.create(name: 'Done', position: 2)

list1.cards.create(name: 'write tests', position: 0)
list1.cards.create(name: 'fix layouts', position: 1)

list2.cards.create(name: 'add auth', position: 2)
list3.cards.create(name: 'install rails', position: 3)
