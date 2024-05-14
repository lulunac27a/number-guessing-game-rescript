let randomInt = (min, max) =>
  Math.floor(Math.random() *. Float.fromInt(max - min + 1)) +. Float.fromInt(min)
@react.component
let make = () => {
  let (level, setLevel) = React.useState(() => 1)
  let (attempts, setAttempts) = React.useState(() => 0)
  let (maxAttempts, setMaxAttempts) = React.useState(() =>
    int_of_float(Math.round(float_of_int(level) *. 0.5))
  )
  let (guess, setGuess) = React.useState(() => 0)
  let (maxGuess, setMaxGuess) = React.useState(() => 2.0 ** float_of_int(level))
  let (secret, setSecret) = React.useState(() => randomInt(1, int_of_float(maxGuess)))
  let (feedback, setFeedback) = React.useState(() => "")

  let updateGuess = evt => {
    Js.log(int_of_string(ReactEvent.Form.currentTarget(evt)["value"]))
    let guessValue = Js.Float.fromString(ReactEvent.Form.currentTarget(evt)["value"])
    if Js.Float.toString(guessValue) != "NaN" || Js.Float.toString(guessValue) != "" {
      setGuess(guess => int_of_float(guessValue))
    }
  }

  let checkGuess = evt => {
    if guess != int_of_float(secret) {
      if guess > int_of_float(secret) {
        setFeedback(feedback => "Too high!")
      } else if guess < int_of_float(secret) {
        setFeedback(feedback => "Too low!")
      }
      setAttempts(attempts => attempts + 1)
      if attempts >= maxAttempts {
        setLevel(level => 1)
        setAttempts(attempts => 0)
        setMaxAttempts(maxAttempts => int_of_float(Math.round(float_of_int(level) *. 0.5)))
        setGuess(guess => 0)
        setMaxGuess(maxGuess => 2.0 ** float_of_int(level))
        setSecret(secret => randomInt(1, int_of_float(maxGuess)))
        setFeedback(feedback => "Game over!")
      }
    } else {
      setLevel(level => level + 1)
      setAttempts(attempts => 0)
      setMaxAttempts(maxAttempts => int_of_float(Math.round(float_of_int(level) *. 0.5)))
      setMaxGuess(maxGuess => 2.0 ** float_of_int(level))
      setSecret(secret => randomInt(1, int_of_float(maxGuess)))
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
      <span id="attempts"> {React.string(Int.toString(attempts))} </span>
    </p>
    <p>
      {React.string("Level: ")}
      <span id="attempts"> {React.string(Int.toString(level))} </span>
    </p>
    <p>
      {React.string("Feedback: ")}
      <span id="attempts"> {React.string(feedback)} </span>
    </p>
  </div>
}
