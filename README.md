# CSE438-Final-Project

# Student ID's

474206,472956,467319

# Known Limitation:
  1. Comments submitted anonymously cannot be deleted.
  2. Due to lack of API for washu course page, we had to input data into the database by hand. Therefore, only a very limited amount of courses are on the app, and only part of them have detail data.
  3. IMPORTANT!!! The Computer Science Department and the African Studies Department are the two department that are data-complete. Use them for your testing.
  4. Upvoting and downvoting comments do not take into account of who has voted, so it is there more for the comment sorting functionality.
  5. Because we cannot confirm the identity of the professor for now, the professor authority is abusable.
  6. You can delete comments of people who share your name. This is a known problem.
  
# Usage:
To use this project, clone the repo, and cd to the directory of this repo and in terminal.
Enter the command: 'pod install'
if you don't have pod, download pod before calling the command

# Log In Section Functionalities:
The Log In Section is set to login on default and allow users to login using email and username. The dropdown menu on the top allows the user to change switch to professor sign up and student signup. The menu also allows the user to switch back to login. The login and signup interface provides proper feedback in the form of alert when the user enters the wrong password/inappropriate username etc. When Signing up, you have to provide a name, an email and a password. The users are divided into two types, the student and professor. The professor will have every functionality a student has, but has the ability to edit some courses in which you are the instructor of (your name that you sign up with matches the name of the instructor of the course.)

# Search/Department Section Functionalities:
After Log In, you will be redirected into a page with a search bar, scroll view and a stackview of buttons to select the school you want to view. If you are a professor, you will have an additional button too edit all your classes. The search bar will allow you to search courses by name, the search result will contain every course from every school and department. (It will be very limited, because we do not have a lot of courses in the database.) The school names at the bottom will allow you to view lists of department from that school. By default, the school is set to Arts&Sciences. By clicking on one of the department, you will see the list of courses from that department. (Only some department contains courses due to limitation described above.) Both search and clicking on department will lead you to another view, and clicking on a specific course will allow you to see the detail information of the course.

# Detail Page and Comments Section Functionalities:
When you click into the detailed page of a course, you will first see the detailed information of this course's different sections in the first tab bar. By clicking differnt segments of the UIsegmentedControll in the view, you can switch between different sections. In the second tab bar, the view will display the statistics of this course's final grade. The data of the course's grade is updated by the instructor of this course. In this view, you can see how many people pass/fail the course, what is the average GPA, and how many people got A, B, C, D in the past semester. In the third tab bar, you can see the comments of the course from other users. The comments are sorted by the amount of likes after being fetched from database. You can either like or dislike a comment. You can also write your own comments by clicking the writing button. In the comment editing view, there is a checkbox on the bottom. After typing in what you want to publish, you can check the box to make this comment anonymous. If the comment is published successfully, the view will go back to the comment view. You can see the comments published by yourself have a delete button. You can delete you own comments at any time. 

# Professor Functionalities:
If user is a professor, he has authority to edit courses. In the search page, there's a Edit Courses Button under under the department section. When click that button, professor will be redirected to another page in which there're all the courses he teach. If there're many section of a certain course and there're many professor teach the same course, if professor teach a certain section of that course, he/she can also see this course. After clicking the cell in that tableview, professor will be redirected to the EditCourse page where he can edit how many people pass/fail the course, what is the average GPA, and how many people got A, B, C, D in the past semester. The data will be stored into firebase and everyone can view the status of that course after editing. 
