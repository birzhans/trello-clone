# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

list1 = List.create(name: 'To Do')
list2 = List.create(name: 'In progress')
list3 = List.create(name: 'Done')

list1.cards.create(name: 'write tests')
list1.cards.create(name: 'fix layouts')

list2.cards.create(name: 'add auth')
list3.cards.create(name: 'install rails')
