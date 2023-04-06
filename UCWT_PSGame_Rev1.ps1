<#
About
    This is a BuzzFeed Quiz style game written in PowerShell.

How to Play
    Run the script, answer prompts as instructed.

Credits
    PowerShell Game assignment, Team Four: Freedom of the PRESS
    UCWT Class 23013
    Christopher Rice, Benjamin Urlik, Shannon Golovach, Parker Myslow
#>

function showTitleScreen {
    # showTitleScreen with ascii art and "what is your spirit animal in a parallel universe based on your vibe?"
    Clear-Host
    @"
    :::::::::       :::::::::       ::::::::::       ::::::::       :::::::: 
    :+:    :+:      :+:    :+:      :+:             :+:    :+:     :+:    :+: 
   +:+    +:+      +:+    +:+      +:+             +:+            +:+         
  +#++:++#+       +#++:++#:       +#++:++#        +#++:++#++     +#++:++#++   
 +#+             +#+    +#+      +#+                    +#+            +#+    
#+#             #+#    #+#      #+#             #+#    #+#     #+#    #+#     
###             ###    ###      ##########       ########       ########       
"@
    Write-Host "Welcome to the Freedom of the PRESS BuzzFeed Quiz!`n`n"
    Write-Host "Today's question to determine...."
    Write-Host "What is your spirit animal in a parallel universe based on your vibe?`n" -ForegroundColor Blue -BackgroundColor Black
    Read-Host "Press ENTER key to continue..."
    Clear-Host
}

function promptQuestion($qObj){
    # Method for pretty-printing a custom Question object, does not return anything once done
    # Takes in a Question custom object as defined above and formats it to be printed nicely
    $textOut = "QUESTION: " + $qObj.body + "`n`n"
    foreach ($item in $qObj.answers.Keys) {
        $textOut += $item + ": " + $qObj.answers.$item.body + "`n"
    }
    Write-Host $textOut
}

function validateAnswer($qObj){
    # Method for validating an answer to a question (by ensuring it is a valid choice from the keys)
    # Returns the provided answer once it is confirmed to be valid
    $validAnswer = $false
    while (-not $validAnswer){
        $providedAnswer = Read-Host -Prompt "Answer with letter of choice"
        if ($providedAnswer.ToUpper() -notin $qObj.answers.Keys) {
            Write-Host "Invalid answer choice provided, please try again..."
        }
        else {
            $validAnswer = $true
        }
    }
    return $providedAnswer
}

function calculateWeight($qObj, $ans){
    # Grab the weights=@{...} for a specific answer that was chosen on a question
    $weightDict = $qObj.answers.$ans.weights
    # For each weight in that dictionary, we need to add that score to the running totals
    foreach ($weight in $weightDict.Keys) {
        # So now, add this score into the running global results totals
            # .$weight is for the Result, then .score for the score to update
            # $weightDict.$weight is the score for the Result stored in $weight
        $global:RESULTS.$weight.score += $weightDict.$weight
    }
}

##### Example for display "finished" message...
function displayResult {
    $outBody = ""
    $highScore = 0
    # Loop through results and find the highest score
    foreach ($result in $RESULTS.Keys) { 
        # "DEBUGGING: Score for $result is " + $RESULTS.$result.score 
        # If that score is now the new winner, write it to variable
        if ($RESULTS.$result.score -gt $highScore) {
            # "DEBUGGING: New high score of " + $RESULTS.$result.score + " for result " + $result
            $highScore = $RESULTS.$result.score
            $outBody = $RESULTS.$result.body
        }
    }
    # Once all possible results have been iterated through and highest is determined, then we can print out that message
    switch($true) {
        {$true} {Write-Host "`n`nThis is the end of the quiz. Thanks for playing!" }
        {-not $false} {Write-Host "`nYour spirit animal in a parallel universe based on your vibe is..." -ForegroundColor Blue -BackgroundColor Black }
        {1} {Write-Host $outBody -ForegroundColor Red -BackgroundColor Black }
    }
}


##### MAIN SECTION #####

##### Prepare the game
# Set up stuff for a quiz... prepare questions
$p1 = @{ColFred=1;Mini=0.7;Perez=0.5;McAdams=0.2;Christensen=0.2;Zolnier=0.2}
$p2 = @{Christensen=1;Perez=0.7;Zolnier=0.5; McAdams=0.2;Mini=0.2;ColFred=0.2}
$p3 = @{McAdams=1;Christensen=0.7;Mini=0.5;Perez=0.2;Zolnier=0.2;ColFred=0.2}
$p4 = @{Mini=1;ColFred=0.7;McAdams=0.5;Perez=0.2;Zolnier=0.2;Christensen=0.2}
$p5 = @{Perez=1;Zolnier=0.7;ColFred=0.5;McAdams=0.2;Christensen=0.2;Mini=0.2}
$p6 = @{Zolnier=1;McAdams=0.7;Christensen=0.5; Perez=0.2;ColFred=0.2;Mini=0.2}

$sq_q1 = [PSCustomObject]@{
    body = "What is your favorite thing to do at the gym?"
    answers = [ordered]@{
        A = @{body="Leg Press"; weights=$p1}
        B = @{body="Bench Press"; weights=$p2}
        C = @{body="Shoulder Press"; weights=$p3}
        D = @{body="Press"; weights=$p4}
    }
}

$sq_q2 = [PSCustomObject]@{
    body = "Are you okay??"
    answers = [ordered]@{
        A = @{body="No, I'm scared you're gonna steal my lunch money:/"; weights=$p5}
        B = @{body="No, I donated my entire paycheck to the Hard Rock"; weights=$p6}
        C = @{body="No, I misinputted a kahoot answer"; weights=$p1}
        D = @{body="No, I spilled coffee all over my macbook ";weights=$p2}
        E = @{body="No, I married a cadet "; weights=$p3}
        F = @{body="No, I started WWIII using navy seals "; weights=$p4}
        G = @{body="No, I forgot the code to my own bike lock "; weights=$p5}
        H = @{body="No, I missed the movie night thrown specifically for me "; weights=$p6}
        I = @{body="No, my analogy was bad "; weights=$p1}
        J = @{body="Yes, I am officially sec+ certified "; weights=$p2}
    }
}

$sq_q3 = [PSCustomObject]@{
    body = "Who has a wide ass?"
    answers = [ordered]@{
        A = @{body="You"; weights=$p3}
        B = @{body="Your mom"; weights=$p4}
        C = @{body="Your dad"; weights=$p5}
        D = @{body="All of the above"; weights=$p6}
        E = @{body="I don't have a wide ass:/"; weights=$p1}
    }
}

$sq_q4 = [PSCustomObject]@{
    body = "Where do you see yourself amongst a class lifting chart?"
    answers = [ordered]@{
        A = @{body="First"; weights=$p1}
        B = @{body="Middle"; weights=$p2}
        C = @{body="I am Jim"; weights=$p3}
        D = @{body="I didn't submit my scores :\";weights=$p4}
    }
}

$sq_q5 = [PSCustomObject]@{
    body = "Which muppet are you?"
    answers = [ordered]@{
        A = @{body="Beaker"; weights=$p5}
        B = @{body="Miss piggy"; weights=$p6}
        C = @{body="Mr. Snuffleupagus"; weights=$p1}
        D = @{body="Statler and Waldorf"; weights=$p2}
        E = @{body="Bert"; weights=$p3}
    }
}

$sq_q6 = [PSCustomObject]@{
    body = "Have you seen Oceans 11?"
    answers = [ordered]@{
        A = @{body="No"; weights=$p4}
        B = @{body="Yes, I LOVE JPP"; weights=$p5}
        C = @{body="What is Oceans 11?"; weights=$p6}
    }
}

$sq_q7 = [PSCustomObject]@{
    body = "Have you ever won multiple kahoots in a row?"
    answers = [ordered]@{
        A = @{body="No, this is not Chris"; weights=$p1}
        B = @{body="Yes, this is Chris"; weights=$p2}
    }
}

$sq_q8 = [PSCustomObject]@{
    body = "Have you ever selected false instead of true on a true/false question because it was on the wrong side?"
    answers = [ordered]@{
        A = @{body="False"; weights=$p3}
        B = @{body="True"; weights=$p4}
        C = @{body="Darth Vader"; weights=$p5}
    }
}

$sq_q9 = [PSCustomObject]@{
    body = "What is 7 x 6?"
    answers = [ordered]@{
        A = @{body="54"; weights=$p6}
        B = @{body="76"; weights=$p1}
        C = @{body="21"; weights=$p2}
    }
}

$sq_q10 = [PSCustomObject]@{
    body = "What is your favorite app?"
    answers = [ordered]@{
        A = @{body="Discourse"; weights=$p3}
        B = @{body="Kahoot"; weights=$p4}
        C = @{body="PowerShell ISE"; weights=$p5}
        D = @{body="Google Slides"; weights=$p6}
    }
}

$sq_q11 = [PSCustomObject]@{
    body = "Pick a chicken sandwich?"
    answers = [ordered]@{
        A = @{body="Chick Fil A"; weights=$p1}
        B = @{body="Popeyes"; weights=$p2}
        C = @{body="Wendys"; weights=$p3}
        D = @{body="McDonalds"; weights=$p4}
    }
}

# QUESTIONS is an array of question objects that will be iterated through
$QUESTIONS = @($sq_q1,$sq_q2,$sq_q3,$sq_q4,$sq_q5,$sq_q6,$sq_q7,$sq_q8,$sq_q9,$sq_q10,$sq_q11)
# RESULTS is a dict of the possible results, their running score, and the associated message you get if you "win" with that result at the end
$global:RESULTS = @{
    ColFred = @{score=0;body="You got Lt Col Frederick!"}
    Perez = @{score=0;body="You got Lt Perez!"}
    McAdams = @{score=0;body="You got Capt McAdams!"}
    Zolnier = @{score=0;body="You got Zolnier!"}
    Mini = @{score=0;body="You got Mini Cooper!"}
    Christensen = @{score=0;body="You got Lt Christensen!"}
}

##### Run the game

showTitleScreen

for ($i = 0; $i -lt $QUESTIONS.length; ++$i) {
    promptQuestion $questions[$i]
    $validAnswer = validateAnswer $questions[$i]
    calculateWeight $questions[$i] $validAnswer
    Clear-Host
}

displayResult

##### END OF GAME #####