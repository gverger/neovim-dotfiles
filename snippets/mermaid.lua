
return {
  s("gnew", fmt([[
  gantt
    title {}
    dateFormat MM-DD-YYYY

    {}
    ]], {i(1), i(0)})),
  s("gsec", fmt([[
  section {}
  ]], {i(1)})),
  s("gtask", fmt([[{} :{}, {}-{}-{}, {}]], {i(1), i(2, "id"), i(3, "DD"), i(4, "MM"), i(5, "YYYY"), i(6, "5d")})),
  s("gafter", fmt([[{} :{}, after {}, {}]], {i(1), i(2, "id"), i(3, "other"), i(4, "5d")})),
}, nil
