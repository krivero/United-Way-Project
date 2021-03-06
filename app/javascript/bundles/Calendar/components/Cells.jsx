import React from 'react';
import dateFns from "date-fns";
import Cell from './Cell';

const Cells = props => {
  const { startDate, endDate } = props;
  const rows = [];
  let days = [];
  let day = startDate;
  while (day <= endDate) {
    for (let i = 0; i < 7; i++) {
      const cloneDay = day;
      days.push(<Cell key={day} day={cloneDay} {...props} />);
      day = dateFns.addDays(day, 1);
    }
    rows.push(<div className="row m-0" key={day}>{days}</div>);
    days = [];
  }
  return(
    <div className="body">{rows}</div>
  );

}

export default Cells;
