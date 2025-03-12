let randomInt = (minimum: float, maximum: float): float => {
  //get random integer
  Math.floor(Math.random() *. (maximum -. minimum +. 1.0)) +. minimum
}
@react.component
let make = () => {
  let (level, setLevel) = React.useState(() => 1) //set initial level to 1
  let (attempts, setAttempts) = React.useState(() => 0) //set initial attempts to 0
  let (score, setScore) = React.useState(() => float_of_int(0)) //set initial score to 0
  let (levelScore, setLevelScore) = React.useState(() => float_of_int(0)) //set initial level score to 0
  let (difficulty, setDifficulty) = React.useState(() => "easy") //set initial difficulty to easy
  let (difficultyMultiplier, setDifficultyMultiplier) = React.useState(() => float_of_int(1)) //set initial difficulty multiplier to 1
  let (attemptsLimit, setAttemptsLimit) = React.useState(() => 10) //set initial attempts limit to 10
  let (mode, setMode) = React.useState(() => "multiplier") //set initial game mode to multiplier
  let (isGameStarted, setIsGameStarted) = React.useState(() => false) //set initial is game started to false (not started)
  let (maxAttempts, setMaxAttempts) = React.useState(() =>
    mode == "multiplier"
      ? int_of_float(Math.round(float_of_int(level) *. difficultyMultiplier))
      : attemptsLimit
  ) //set max attempts based on level, difficulty and game mode
  let (guess, setGuess) = React.useState(() => float_of_int(0)) //set initial guess value to 0
  let (maxGuess, setMaxGuess) = React.useState(() => 2.0 ** float_of_int(level)) //set max guess value to 2 raised to level
  let (secret, setSecret) = React.useState(() => randomInt(float_of_int(1), maxGuess)) //set secret value to random integer from 1 to max guess value
  let (feedback, setFeedback) = React.useState(() => "") //set initial feedback to empty string

  let startGame = evt => {
    //start game when start button is pressed
    if !isGameStarted {
      //start game if game is not started
      setLevel(level => 1)
      setAttempts(attempts => 0)
      setScore(score => float_of_int(0))
      setLevelScore(levelScore => float_of_int(0)) //set level score to 0
      setMaxAttempts(maxAttempts =>
        mode == "multiplier"
          ? int_of_float(Math.round(float_of_int(1) *. difficultyMultiplier))
          : attemptsLimit
      )
      setGuess(guess => float_of_int(0))
      setMaxGuess(maxGuess => 2.0 ** float_of_int(1))
      setSecret(secret => randomInt(float_of_int(1), float_of_int(2)))
      setIsGameStarted(isGameStarted => true) //set is game started to true
    }
  }
  let updateGuess = evt => {
    //update guess value when key is pressed
    let guessValue = Js.Float.fromString(ReactEvent.Form.currentTarget(evt)["value"])
    if Js.Float.toString(guessValue) != "NaN" || Js.Float.toString(guessValue) != "" {
      //if guess value is a valid number
      setGuess(guess => guessValue) //set guess value to value of text input for guess
    }
  }

  let updateDifficulty = evt => {
    //update difficulty when difficulty selection is changed
    let difficultyValue = ReactEvent.Form.currentTarget(evt)["value"]
    switch difficultyValue {
    //set difficulty to value of difficulty selection
    | "easy" =>
      //easy difficulty
      if mode == "multiplier" {
        setDifficulty(_ => "easy")
        setDifficultyMultiplier(_ => 1.0)
      } else {
        setAttemptsLimit(_ => 10)
      }
    | "medium" =>
      //medium difficulty
      if mode == "multiplier" {
        setDifficulty(_ => "medium")
        setDifficultyMultiplier(_ => 0.75)
      } else {
        setAttemptsLimit(_ => 8)
      }
    | "hard" =>
      //hard difficulty
      if mode == "multiplier" {
        setDifficulty(_ => "hard")
        setDifficultyMultiplier(_ => 0.5)
      } else {
        setAttemptsLimit(_ => 5)
      }
    | "expert" =>
      //expert difficulty
      if mode == "multiplier" {
        setDifficulty(_ => "expert")
        setDifficultyMultiplier(_ => 0.25)
      } else {
        setAttemptsLimit(_ => 3)
      }
    | _ => {
        setDifficulty(_ => "easy")
        setDifficultyMultiplier(_ => 1.0)
      }
    }
  }

  let updateMode = evt => {
    //update game mode when mode selection is changed
    let modeValue = ReactEvent.Form.currentTarget(evt)["value"]
    switch modeValue {
    //set mode to value of mode selection
    | "multiplier" => setMode(_ => "multiplier")
    | "attempts" => setMode(_ => "attempts")
    | _ => setMode(_ => "multiplier")
    }
  }
  let checkGuess = evt => {
    //check if guess is equal to secret number
    if Js.Float.isFinite(guess) {
      //if guess is a valid number
      if guess >= 1.0 && guess <= maxGuess {
        //if guess is within range
        if guess != secret {
          //if guess is not equal to secret number
          if guess > secret {
            //too high
            setFeedback(feedback => "Too high!")
          } else if guess < secret {
            //too low
            setFeedback(feedback => "Too low!")
          }
          setLevelScore(levelScore =>
            levelScore +.
            maxGuess *.
            Math.min(
              Math.max(guess, 1.0) /. Math.max(secret, 1.0),
              Math.max(secret, 1.0) /. Math.max(guess, 1.0),
            ) *.
            (1.0 -. Math.abs(secret -. guess) /. Math.max(secret, secret -. guess +. 1.0)) *. (
              guess < secret
                ? guess /. secret
                : (maxGuess -. guess +. 1.0) /. (maxGuess -. secret +. 1.0)
            )
          ) //increase level score
          setAttempts(attempts => attempts + 1) //increase attempts by 1
          if attempts >= maxAttempts {
            //if all attempts used reset game to initial state
            setFeedback(feedback => "Game over! Your score is " ++ Js.Float.toString(score) ++ ".")
            setMaxAttempts(maxAttempts =>
              mode == "multiplier"
                ? int_of_float(Math.round(float_of_int(1) *. difficultyMultiplier))
                : attemptsLimit
            )
            setMaxGuess(maxGuess => 2.0 ** float_of_int(1))
            setLevel(level => 1)
            setAttempts(attempts => 0)
            setScore(score => float_of_int(0))
            setLevelScore(levelScore => float_of_int(0)) //set level score to 0
            setGuess(guess => float_of_int(0))
            setSecret(secret => randomInt(float_of_int(1), float_of_int(2)))
            setIsGameStarted(isGameStarted => false) //set is game started to false
          }
        } else {
          //if guess is equal to secret number
          setFeedback(feedback =>
            "You guessed correctly! +" ++
            Js.Float.toString(
              Math.round(
                (levelScore +. maxGuess) *.
                float_of_int(maxAttempts - attempts + 1) /.
                float_of_int(attempts + 1) *.
                float_of_int(maxAttempts),
              ),
            ) ++ " points!"
          )
          setSecret(secret => randomInt(float_of_int(1), maxGuess *. 2.0)) //get random secret guess number
          setScore(score =>
            score +.
            Math.round(
              (levelScore +. maxGuess) *.
              float_of_int(maxAttempts - attempts + 1) /.
              float_of_int(attempts + 1) *.
              float_of_int(maxAttempts),
            )
          ) //increase score by level score
          setMaxGuess(maxGuess => 2.0 ** float_of_int(level + 1)) //increase max guess number by double
          setMaxAttempts(maxAttempts =>
            mode == "multiplier"
              ? int_of_float(Math.round(float_of_int(level + 1) *. difficultyMultiplier))
              : attemptsLimit
          ) //increase max attempts based on difficulty for multiplier game mode and set fixed number of attempts for attempts mode
          setLevel(level => level + 1) //increase level by 1
          setAttempts(attempts => 0) //set attempts to 0
          setLevelScore(levelScore => float_of_int(0)) //set level score to 0
        }
      }
    }
  }

  <div className="p-4">
    <h1 className="text-2xl font-bold"> {React.string("Number Guessing Game in ReScript")} </h1>
    <p> {React.string("Choose a game mode:")} </p>
    <select id="mode" value={mode} onChange={updateMode}>
      <option value="multiplier">
        {React.string("Attempts with multiplier based on level")}
      </option>
      <option value="attempts"> {React.string("Fixed number of attempts")} </option>
    </select>
    <br />
    <p> {React.string("Choose a difficulty level:")} </p>
    <select id="difficulty" value={difficulty} onChange={updateDifficulty}>
      <option value="easy"> {React.string("Easy")} </option>
      <option value="medium"> {React.string("Medium")} </option>
      <option value="hard"> {React.string("Hard")} </option>
      <option value="expert"> {React.string("Expert")} </option>
    </select>
    <br />
    <Button disabled={isGameStarted} onClick={startGame}> {React.string("Start")} </Button>
    <p> {React.string("Guess a number from 1 to " ++ Float.toString(maxGuess))} </p>
    {React.string("Guess: ")}
    <NumberInput id="guess" min="1" max={Float.toString(maxGuess)} onChange={updateGuess} />
    <br />
    <Button onClick={checkGuess} disabled={!isGameStarted}> {React.string("Guess!")} </Button>
    <br />
    <p>
      {React.string("Guesses Left: ")}
      <span id="attempts-left"> {React.string(Int.toString(maxAttempts - attempts))} </span>
    </p>
    <p>
      {React.string("Level: ")}
      <span id="level"> {React.string(Int.toString(level))} </span>
    </p>
    <p>
      {React.string("Score: ")}
      <span id="score"> {React.string(Float.toString(score))} </span>
    </p>
    <p>
      {React.string("Feedback: ")}
      <span id="feedback"> {React.string(feedback)} </span>
    </p>
  </div>
}
