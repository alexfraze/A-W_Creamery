Original:

1. add nested forms
2. add authentication from specs sheet
    1. check if inactive employees should  be shown to managers and if so how do i get inactive employees store?
    2. write all authorization code
    3. test
    4. check that views work with authorization (test)
    5. do I put cancan code in controller or in views (or both?)
2. add js to make interactions easier
3. add in controllers for jobs, shifts, and flavors
3. make an option to reschedule last weeks shifts and make some changes
4. make a save and save + create new option for shifts
5. datepicker
6. check against phase 1 use cases
7. change color theme and pictures
8. piazza questions check
9. comment code and user test
10. password test that it is updating
11. add phase 3 asthentics and new logo. maybe more colors and asethicts but its only worth 10 pts so dont do too much here.
12. write a design notes section in the read-me about certain design choices and features of my phase 5 project.

Current:
1. add nested forms
2. write all authorization code (needs to be tested)
3. write controllers (**shifts**, **flavors**, jobs) and basic index view for each
4. write new and form views for each ----- still needs to be done
5. work on some shift views and interactions
    *add all past shifts and all future shift pages
   
4/30/16
- add start and end buttons for shifts for an employee



OH May 2nd
Questions:
1. New Shift DatePicker format/proper way to include JS in rails
**2. Does EC for testing count for 1% of project or 1% of class grade?**
*3. pagination issues for multiple lists on same page 
4. increaseing load time for authorization of lists of shifts and such?
5. I removed validates presence of shift_id and change active_shift validation to on update. Simiiliar to employee situation and for store-flavors nested in store, is this ok? this is ok. **change to checkboxs**
6. duplicates of added shift jobs and store flavors. (bugs with adding a new job and old ones getting re added) also forms chaning to numbers on edit/update vs. create/new
7. what to use javascript for?



STill need to do as of may 2:
- adding future shifts for a week (employee, all employees, add another)
- remove the add multiple users option
- allow users to edit their own info but not their ssns


- colors and picture changes

Views: as employee cant see edit and delete store buttons
-assignments only viewable to employee or right manager

cant add employee as manager or employee

Need to change back at end:
shift scopes changes to 3 days to make for quicker load. (6-7 days?)
run through all auths and make sure they are doing what they are supposed to.
- past and future shifts as seperate controller actions fix this
- write and make sure all tests for controllers and models are passing
- finish writing style notes in read me_
- piazza questions incorporate

Grading disputes:
1. no dashboards but custome routing takes users directly to their most important page which is basically a dashboard and should get some points back.
2. can create user with employee -- nested form does work and can add user to an employee -- my view was screwed up but this does work.
3. marked off in 3 places for not being able to edit self info
4. my mass assign shifts doesnt work but it does work if you remove the bang! ??
