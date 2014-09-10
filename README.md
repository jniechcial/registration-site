README
=======
This is a registration site created for [Cyberbot Robotics Festival](http://cyberbot.put.poznan.pl/) that was being held in Poznań. We needed an application that will let potential competitors register and join and create teams and create records for their robots in particular competition. Moreover, it should have functionality of admin user to get all registered users, teams and robots in CSV format. 

Live demo is accessible via [this link](http://cyberbot.herokuapp.com/).

1. Functionality.
-----------------
The application allows user to:
* register
* create a team
* query to join an existing team
* create robot within a team for particular competition
* creator of a team can accept or decline queries to that team from other users

This repo has two branches - one with custom authentication method based on [Michael Hartl](https://www.railstutorial.org/) Rails tutorial and the other one moved to [Devise Gem](https://github.com/plataformatec/devise).

2. Tests.
--------
The application is quite widely tested. The branch that uses custom authentication method is fully tested and the other one based on Devise is tested without devise functionality of authentication.

3. Usage.
--------
It may be used (with little adaption) as a registration system for various events that demands users, teams and competition subjects (such as robots, in that case). Please feel free to use it as you like - it is completely open source, even if I do not know under what license I should sign it :)
