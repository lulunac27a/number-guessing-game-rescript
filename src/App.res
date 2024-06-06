let randomInt = (minimum: float, maximum: float) => {
  //get random integer
  Math.floor(Math.random() *. (maximum -. minimum +. 1.0)) +. minimum
}
@react.component
let make = () => {
  let (level, setLevel) = React.useState(() => 1) //set initial level to 1
  let (attempts, setAttempts) = React.useState(() => 0) //set initial attempts to 0
  let (score, setScore) = React.useState(() => float_of_int(0)) //set initial score to 0
  let (levelScore, setLevelScore) = React.useState(() => float_of_int(0)) //set initial level score to 0
  let (maxAttempts, setMaxAttempts) = React.useState(() =>
    int_of_float(Math.round(float_of_int(level) *. 0.5))
  )
  let (guess, setGuess) = React.useState(() => float_of_int(0)) //set initial guess value to 0
  let (maxGuess, setMaxGuess) = React.useState(() => 2.0 ** float_of_int(level)) //set max guess value to 2 raised to level
  let (secret, setSecret) = React.useState(() => randomInt(float_of_int(1), maxGuess)) //set secret value to random integer from 1 to max guess value
  let (feedback, setFeedback) = React.useState(() => "") //set initial feedback to empty string

  let updateGuess = evt => {
    //update guess value when key is pressed
    let guessValue = Js.Float.fromString(ReactEvent.Form.currentTarget(evt)["value"])
    if Js.Float.toString(guessValue) != "NaN" || Js.Float.toString(guessValue) != "" {
      //if guess value is a valid number
      setGuess(guess => guessValue) //set guess value to value of text input for guess
    }
  }

  let checkGuess = evt => {
    //check if guess is equal to secret number
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
        levelScore +. maxGuess *. Math.min(guess /. secret, secret /. guess)
      ) //increase level score
      setAttempts(attempts => attempts + 1) //increase attempts by 1
      if attempts >= maxAttempts {
        //if all attempts used reset game to initial state
        setLevel(level => 1)
        setAttempts(attempts => 0)
        setScore(score => float_of_int(0))
        setLevelScore(levelScore => float_of_int(0)) //set level score to 0
        setMaxAttempts(maxAttempts => int_of_float(Math.round(float_of_int(level) *. 0.5)))
        setGuess(guess => float_of_int(0))
        setMaxGuess(maxGuess => 2.0 ** float_of_int(level))
        setSecret(secret => randomInt(float_of_int(1), maxGuess))
        setFeedback(feedback => "Game over!")
      }
    } else {
      //if guess is equal to secret number
      setLevel(level => level + 1) //increase level by 1
      setScore(score =>
        score +.
        Math.round(
          levelScore *.
          float_of_int(maxAttempts - attempts + 1) /.
          float_of_int(attempts + 1) *.
          float_of_int(maxAttempts),
        )
      ) //increase score by level score
      setAttempts(attempts => 0) //set attempts to 0
      setLevelScore(levelScore => float_of_int(0)) //set level score to 0
      setMaxAttempts(maxAttempts => int_of_float(Math.round(float_of_int(level) *. 0.5))) //increase max attempts by 0.5
      setMaxGuess(maxGuess => 2.0 ** float_of_int(level)) //increase max guess number by double
      setSecret(secret => randomInt(float_of_int(1), maxGuess)) //get random secret guess number
      setFeedback(feedback => "You guessed correctly!")
    }
  }

  <div className="p-4">
    <h1 className="text-2xl font-bold"> {React.string("Number Guessing Game in ReScript")} </h1>
    <p> {React.string("Guess a number from 1 to " ++ Float.toString(maxGuess))} </p>
    {React.string("Guess: ")}
    <NumberInput id="guess" min="1" max={Float.toString(maxGuess)} onChange={updateGuess} />
    <br />
    <Button onClick={checkGuess}> {React.string("Guess!")} </Button>
    <br />
    <p>
      {React.string("Guesses Left: ")}
      <span id="attempts"> {React.string(Int.toString(maxAttempts - attempts))} </span>
    </p>
    <p>
      {React.string("Level: ")}
      <span id="attempts"> {React.string(Int.toString(level))} </span>
    </p>
    <p>
      {React.string("Score: ")}
      <span id="score"> {React.string(Float.toString(score))} </span>
    </p>
    <p>
      {React.string("Feedback: ")}
      <span id="attempts"> {React.string(feedback)} </span>
    </p>
  </div>
}
