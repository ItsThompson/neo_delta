<div align="center">
<pre>
                       _      _ _        
                      | |    | | |       
  _ __   ___  ___   __| | ___| | |_ __ _ 
 | '_ \ / _ \/ _ \ / _` |/ _ \ | __/ _` |
 | | | |  __/ (_) | (_| |  __/ | || (_| |
 |_| |_|\___|\___/ \__,_|\___|_|\__\__,_|
                                         
-----------------------------------------------------------------------------------------
A multi-platform habit tracker mobile app with an emphasis on motivating users through their own progression.

</pre>

![GitHub top language](https://img.shields.io/github/languages/top/ItsThompson/neo_delta)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/ItsThompson/neo_delta/main)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/ItsThompson/neo_delta)

</div>

## Introduction
This project is a [Flutter](https://flutter.dev/) based app focused on building optimizing building new habits whilst maintaining old habits. The underlying system of calculating the change (delta), of a habit (known as a Recurring Delta) is heavily inspired by the video [Maintaining Other Skills while Focusing on a Main Skill](https://www.youtube.com/watch?v=3wkBd1WnAGo) produced on the YouTube channel (Outperform) which expanded the concept of Dr. Mike Israetel's training tips for hypertrophy (Detailed in his [blog](https://rpstrength.com/blogs/articles/training-volume-landmarks-muscle-growth)) to the world of developing new skills.

From this concept, I created a [mathematical model](https://www.desmos.com/calculator/ejucssx4oc) to calculate the amount of positive or negative "delta" according to the amount of volume/completions done.

Through this project, I was able to learn a lot on using Flutter including app state managment, database design, and flutter routing.

## Showcase

https://github.com/ItsThompson/neo_delta/assets/33135895/90a6f0bc-3e7a-4734-a033-baa7948f6677

## Dependencies
  - cupertino_icons: ^1.0.2
  - go_router: ^13.1.0
  - provider: ^6.1.1
  - fl_chart: ^0.66.1
  - sqflite: ^2.3.2
  - path: ^1.8.3
  - format: ^1.4.0

## Future Plans
  -  [ ] Add yellow borders for days with landmark Deltas in the Stat pageviews
  -  [ ] Social Tab to share progress with friends
  -  [ ] Filter recurring deltas in stats
