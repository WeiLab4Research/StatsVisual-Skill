# 统一规格与绘图工具

Schema：[figure.schema.json](../schemas/figure.schema.json)。用JSON描述实际研究内容和可复现布局；代码采用pt坐标，不使用旧版rank/lane英寸规格。旧版5个模板已按新格式迁移，数字未知保留null，不能直接作为研究成图。

## 最小结构
```json
{
  "schema_version":"2.4",
  "metadata":{
    "type":"02-observational-selection",
    "purpose":"呈现纳排与最终分析人群",
    "study_design":"retrospective cohort",
    "journal":"general",
    "proposal_version":"v1",
    "guidance":[]
  },
  "nodes":[
    {"id":"eligible","label":"Eligible participants","count":null,"unit":"participants","source":"manuscript Methods, paragraph 2","x":0,"y":0,"w":150}
  ],
  "edges":[]
}
```

`metadata.guidance`记录实际适用规范和期刊要求的版本、URL、checked_on、status与applies_to，不能用空数组冒充已核验；无适用固定规范时也在方案解释依据。`purpose`和`study_design`不入画布。`unresolved`非空会阻止最终生成。

节点字段：`id,label,source`必需；`x,y,w,h`均为pt。简单纵向图可用`rank,lane`代替x/y，默认每层90 pt、列距170 pt，文字变长仍需重排。shape取rect/diamond/ellipse/text；text只用于时间、分层或面板等结构标签，不能塞入标题和注释。`count`是单一明确单位的整数；null表示未知。`parent`允许包含，外框用container=true；框内文字应使用独立结构文本节点并安排不遮挡子框。

连线必需`id,from,to,relation,source`。relation区分flow/exclusion/assignment/data/temporal/causal/hypothesis/decision/service/information/feedback/association。默认从底到顶正交连线；复杂路径用`points:[[x,y],...]`定义完整起止路由；`arrow:false`表示无向关联。`from_port/to_port`可选上下左右。连线标签用`label`及显式基线坐标`label_at:[x,y]`，所有格式保留。概念/逻辑框架可保留来源明确的反馈关系。

`equations`只表示同单位、已声明disjoint和exhaustive的分割；总数total和分项parts引用节点ID，source解释算式依据。不同单位不自动换算。时间窗用`time_windows`记录起止、单位、零点、出处；坐标对应的时间比例由方案和生成器负责，检查器仅检查区间合法，不能证明零点方法正确。

## 确认记录
先把当前方案展示给用户并结束该轮。实际收到确认后，完善与方案一致的spec，再运行：
```bash
python scripts/validate_spec.py project/spec.json --record-confirmation "用户实际确认原话"
```
这会将当前内容摘要和方案版本写入approval；不得替用户发明确认。之后修改spec会使摘要失效。纯排版变化可沿用已授权方案，重核对后重新记录原确认；研究事实或结构改变必须先取得新的确认。

## 渲染和检验
```bash
python scripts/render.py project/spec.json --out-dir project/deliverables --name figure
python scripts/check.py project/spec.json project/deliverables/figure --preview project/internal-preview.png
```
依赖见scripts/requirements.txt。默认优先Arial；中文存在缺字时用SimHei，其他系统配置style.font_file/cjk_font_file。所选字体需要可嵌入和完整字形；SVG子集嵌入、PDF嵌入字体。PPTX使用原生文字并引用字体名，不嵌入字体，接收电脑需安装同字体；必须说明这一可移植性边界。

render仅按显式关系绘图，不自动选择医学结论。图内无图题和注释，最终只交付SVG/PPTX/PDF；内部PNG、proposal、spec和报告留在项目工作目录。



## Priority types, custom route and version
Schema 2.4 accepts the eight priority IDs and custom. The eight folders remain reference entry points, not a capability ceiling. See [custom design](custom-design.md) for the required eight-dimensional plan in metadata.custom_design; custom panels also require it. Standard approval and source/geometry checks remain. Existing projects need a specification review and updated confirmation digest when migrated; no external study files are changed by this update.

## Trunk attachment and text fitting
`branch_from` names the main edge supporting a side exit; `branch_segment` selects its segment (default 0), and `branch_fraction` selects an interior point (default 0.5, strictly between 0 and 1). A branch keeps the trunk upstream node in `from`, cannot combine branch_from with absolute points, and must not reference another branch. Exclusion relations require this explicit attachment. Provide correct node positions to align the side box with the junction; the engine does not invent a medically meaningful layout.

`w` is a wrapping limit with default shrink-to-text; `fit_width:false` keeps the requested width. The centre of the requested horizontal slot stays fixed as width shrinks. Auto height is measured text plus padding, not a 60 pt minimum. Explicit h remains an intentional override. Count position may be prefix or separate. Brief reference observations may stay in the proposal; a separate reference-review.md is optional.

Side boxes default to align_branch:true: their vertical centre is aligned with the selected trunk junction before collision checks. For deliberate offset boxes or nonvertical trunks, use align_branch:false and specify a clear route/layout. This moves boxes only; it does not add or remove study content.


## Flexible dimensions and independent layout
Numerical defaults are implementation starting values, not exact layout targets. Adjust gaps, padding and box sizes by legibility and visual balance. Side boxes normally align vertically to their trunk junction; align_branch:false preserves a deliberate offset. width_group coordinates measured peer widths, while fit_width:false preserves an intentionally fixed width.

When no reference is suitable, follow [independent layout](independent-layout.md), propose a coherent composition from the approved content, and obtain confirmation as usual. Do not require examples, exact coordinates from the user or a separate review document to proceed. One overall visual review is normally sufficient; fix real content, routing or readability problems rather than negligible numerical differences.
