let make = props => {
  let className =//check if button is disabled
    if (props.disabled) {//if button is disabled
      "inline-block px-2 py-2 text-white font-bold bg-gray-600"//set background color to gray
    } else {
      "inline-block px-2 py-2 text-white font-bold bg-green-600"//set background color to green
    }
  <button {...props} className={className} />
}
