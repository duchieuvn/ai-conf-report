# I need to present the entire paper in 20 minutes

Give me a Markdown that capture the key features of the paper for 20 minutes talk

You can use the following Markdown as a script/slide basis for a 20‑minute talk on the paper. It covers motivation, method, experiments, and takeaways in a presentation-friendly structure.[^1]

---

# Unifying Global and Local Scene Entities Modelling for Precise Action Spotting

## 1. Title \& Context

- **Title**: Unifying Global and Local Scene Entities Modelling for Precise Action Spotting
- **Domain**: Action spotting in sports videos (e.g., soccer, diving, gymnastics).
- **Goal**: Detect _precise timestamps_ of events (cards, goals, dives, gym transitions) rather than long temporal segments.[^1]

---

## 2. Motivation \& Problem Setting

### 2.1 Why Action Spotting in Sports?

- Used for highlight generation, analytics, broadcasting automation, and downstream retrieval.[^1]
- Requires high temporal precision: detect single timestamps rather than coarse intervals.[^1]

### 2.2 Challenges in Sports Broadcasts

- **Cluttered scenes**: crowds, advertising boards, camera motion introduce strong background noise.[^1]
- **Rapid camera changes**: cuts and zooms make temporal reasoning harder.[^1]
- **Small key objects**: balls, yellow/red cards, or fine-grained body poses occupy tiny regions in the frame.[^1]
- **Severe class imbalance**: most frames are background; rare events (e.g., red cards) are extremely under-represented.[^1]

### 2.3 Limitations of Prior Work

- Standard pipelines = global backbone + temporal model, trained mostly on **global frame features**.[^1]
- These behave like black boxes, often missing small but semantically critical entities (ball, cards, etc.).[^1]
- Two-phase approaches (e.g., Baidu, Yahoo) depend on heavy 3D backbones and multiple feature extractors; end-to-end methods (e.g., E2E-Spot) are lighter but still global-only.[^1]

---

## 3. Task Definition \& Datasets

### 3.1 Action Spotting Task

- Input: an untrimmed sports video and a set of action classes.[^1]
- Output: a _sparse_ set of timestamps, each with an action label, indicating when an event occurs.[^1]
- Evaluation: mean AP over temporal tolerances, including tight tolerances (1–5 seconds) to measure precise spotting.[^1]

### 3.2 Datasets

- **SoccerNet‑v2**: ~550 matches (around 764 hours, >300k labeled spots), with strong clutter, camera changes, small soccer objects, and imbalanced classes.[^1]
- **FineDiving**: 3,000 diving clips; action spots correspond to transitions between dive phases (e.g., entry, twist, somersault types).[^1]
- **FineGym**: 5,374 gym performances; 32 spotting classes derived by converting action segments into timestamp-level events.[^1]

---

## 4. High-Level Idea of UGL

### 4.1 Key Insight

- Human perception of actions relies on:
  - Understanding the **global environment** (pitch, court, scene context).
  - Focusing on **local entities** that are physically involved in the action (ball, players, cards, etc.).[^1]
- The proposed **Unifying Global and Local (UGL)** module explicitly **disentangles**:
  - A _global environment feature_.
  - A _local relevant scene entities feature_.[^1]

### 4.2 Overall Pipeline

1. Sample a snippet of $T$ consecutive frames from the video.[^1]
2. For each frame:
   - Extract global environment features via a 2D backbone + time-shift module.
   - Extract local entity features via a vision–language model (GLIP) + adaptive attention.[^1]
3. Fuse global and local features into a unified representation per frame.[^1]
4. Feed the frame-wise sequence into a **Long-Term Temporal Reasoning (LTR)** module based on a bidirectional GRU.[^1]
5. Predict per-frame class scores; apply non-maximum suppression over time to obtain event timestamps.[^1]

---

## 5. UGL Module: Global \& Local Features

### 5.1 Global Environment Feature

- Backbone: **RegNet‑Y**, a 2D CNN chosen for design efficiency and low computation compared to VGG/ResNet/EfficientNet.[^1]
- Temporal modeling in the backbone:
  - Integrates **Gate-Shift Module (GSM)**, a time-shift mechanism.
  - GSM shifts feature maps forward and backward along the temporal axis to share information across frames, acting as a lightweight alternative to full 3D CNNs.[^1]
- Result: a global environment feature vector per frame capturing spatial and short-term temporal context.[^1]

### 5.2 Local Relevant Scene Entities via GLIP

- Motivation: global features alone often ignore small but crucial entities (cards, ball, etc.), especially under class imbalance.[^1]
- Use **GLIP** (Grounded Language-Image Pre-training) as a **training-free vision–language detector**:
  - GLIP takes:
    - The frame image.
    - A text prompt listing sports-related entities (e.g., “ball, yellow card, red card, referee…”).[^1]
  - A language encoder (e.g., BERT) processes the text into word features; a visual encoder (Swin backbone) produces image proposals.[^1]
  - A deep fusion encoder with cross-modal multi-head attention aligns proposals with textual entities.[^1]
- From GLIP outputs:
  - Use RoIAlign on the visual feature map to extract features for each detected entity box.[^1]
  - This yields a set of candidate entity features for the frame.[^1]

### 5.3 Adaptive Attention Mechanism (AAM)

- Problem: not all detected entities are equally relevant for the current action.[^1]
- Solution: **AAM** takes both:
  - Local entity features from GLIP.
  - The global environment feature.
- AAM uses:
  - A **hard attention** stage to select the most promising entities.
  - A **soft self-attention** stage to fuse them into a single compact local-entity representation.[^1]
- Output: a **local relevant scene entities feature** per frame emphasizing objects crucial for the action.[^1]

### 5.4 Fusion of Global and Local

- Concatenate:
  - Global environment feature.
  - Local relevant entities feature.[^1]
- Apply:
  - A self-attention layer to model interactions between these components.
  - Average pooling to obtain a unified **entities–environment representation** for each frame.[^1]
- This fused feature captures both background scene context and the semantics of key objects.[^1]

---

## 6. Long-Term Temporal Reasoning (LTR)

### 6.1 Temporal Encoder

- Input: sequence of fused frame features for a $T$-frame snippet.[^1]
- Temporal modeling:
  - 1-layer **bidirectional GRU** to capture semantic relationships along the snippet.[^1]
- Prediction head:
  - Fully connected layer + softmax at each time step to produce per-frame class scores (including background).[^1]

### 6.2 Inference with Sliding Window

- Slide a window of $T$ frames over the entire video with overlap.[^1]
- Obtain frame-wise scores from GRU for each snippet and merge them; then:
  - Apply **Non-Maximum Suppression (NMS)** in time to reduce overlapping detections.
  - Final output: a set of temporally precise event spots.[^1]

---

## 7. Training Methodology \& Loss Design

### 7.1 Class Imbalance in Sports

- Example: In SoccerNet‑v2, background frames dominate; non-background classes account for only around 2% of frames.[^1]
- Rare events: red card, yellow-to-red, penalties have very few samples compared to common events or background.[^1]

### 7.2 Focal Loss

- Instead of standard cross-entropy, the network uses **Focal Loss**:
  - Down-weights easy examples with high predicted probability.
  - Focuses learning on hard, misclassified, or minority-class examples.
  - Includes a balancing parameter to control class weighting.[^1]
- Applied per frame over the snippet’s predicted multi-class outputs.[^1]

### 7.3 Implementation Details (Key Points)

- Global branch: RegNet‑Y initialized from ImageNet‑1K.[^1]
- Local branch: GLIP‑L (Swin‑Large backbone) used as pre-trained visual–language model; no fine-tuning needed.[^1]
- Training:
  - Randomly sampled snippets of **100 frames**.
  - Data augmentation: cropping, jittering, mixup; resize frames to height 224, with dataset-specific cropping.[^1]
  - Optimizer: AdamW with linear warm-up and cosine learning rate scheduling.[^1]
- Training setup:
  - Single NVIDIA A100 80GB.
  - ~150 epochs for SoccerNet‑v2 and FineGym; ~50 epochs for FineDiving.[^1]

---

## 8. Evaluation: Metrics \& Setups

### 8.1 Metrics

- **mAP** per class at a fixed temporal tolerance.[^1]
- **Average-mAP (A-mAP)**: area under the mAP vs tolerance curve across a range of tolerances.[^1]
- **Tight Average-mAP (T‑mAP)**:
  - Focuses on tolerances from 1 to 5 seconds.
  - Better reflects how precisely the model spots events.[^1]

### 8.2 Experimental Scenarios

- SoccerNet‑v2: train/val/test splits plus challenge set; final model trained on combined splits and evaluated on challenge leaderboard.[^1]
- FineDiving \& FineGym: compare against:
  - Pre-trained feature baselines.
  - Fine-tuned feature models.
  - VC-Spot (video classification baseline).
  - E2E-Spot as strong end-to-end baseline.[^1]

---

## 9. Quantitative Results

### 9.1 SoccerNet‑v2 Challenge

- UGL reaches **top‑1 rank** on the SoccerNet‑v2 action spotting challenge leaderboard.[^1]
- Achieves **69.38% T‑mAP**, outperforming:
  - **E2E‑Spot** (same end-to-end family) by about **2.65% T‑mAP**.[^1]
  - Two-phase systems Baidu and Soares by large margins (e.g., about **19.82%** and **1.57% T‑mAP** respectively).[^1]
- Strong gains especially on **shown actions** (visible in the frame); two-phase SOTA retains slight advantage only on unshown events.[^1]

### 9.2 FineDiving \& FineGym

- Across different setups (pre-trained features, fine-tuned features, VC-Spot baseline):
  - UGL consistently yields higher mAP than baselines.[^1]
- Compared to E2E‑Spot without optical flow:
  - On **FineDiving**, UGL improves mAP by about **2.4%** at selected tolerances.
  - On **FineGym**, UGL improves mAP by about **1.3%**.[^1]

### 9.3 Quantitative Results in LaTeX Tables

\begin{table}[h]
\centering
\caption{SoccerNet-v2 challenge quantitative comparison (T-mAP).}
\label{tab:soccernet_results}
\begin{tabular}{lccc}
\hline
Method & T-mAP (\%) & Gap to UGL (\%) & Notes \\
\hline
UGL (ours) & 69.38 & 0.00 & Top-1 on challenge leaderboard \\
E2E-Spot & 66.73 & -2.65 & End-to-end baseline \\
Baidu (two-phase) & 49.56 & -19.82 & Computed from reported margin \\
Soares (two-phase) & 67.81 & -1.57 & Computed from reported margin \\
\hline
\end{tabular}
\end{table}

\begin{table}[h]
\centering
\caption{FineDiving and FineGym improvements of UGL over E2E-Spot (no optical flow).}
\label{tab:finediving_finegym_results}
\begin{tabular}{lcc}
\hline
Dataset & $\Delta$ mAP of UGL (\%) & Comment \\
\hline
FineDiving & +2.4 & At selected temporal tolerances \\
FineGym & +1.3 & Consistent gain over baseline \\
\hline
\end{tabular}
\end{table}

---

## 10. Conclusion

### 10.1 Key Findings

- UGL unifies global environment features and local scene-entity features to produce a compact, interpretable per-frame representation that improves spotting precision.
- State-of-the-art performance on SoccerNet‑v2: **69.38% T‑mAP** (Top‑1 on the leaderboard), outperforming E2E‑Spot by ~**2.65%** T‑mAP; consistent gains on FineDiving (+2.4% mAP) and FineGym (+1.3% mAP).[^1]
- The Adaptive Attention Mechanism (AAM) effectively selects and fuses relevant detected entities, yielding notable improvements on small-object and long‑tail classes (e.g., penalty, red card, yellow‑to‑red).
- For temporal modeling and imbalance handling, a 1-layer bidirectional GRU combined with Focal Loss provides strong, reliable performance across datasets.

### 10.2 Conclusion and Implications

- UGL demonstrates that explicitly modeling and fusing entity-level and environment-level cues is an effective, interpretable strategy for precise action spotting in sports video.
- The approach balances accuracy and efficiency: competitive with heavier two‑phase systems while remaining end‑to‑end and explainable via detected entities and attention maps.
- Practical applications include automated highlight generation, broadcast assistance, and downstream retrieval; natural next steps are richer entity relationship modeling (e.g., GNNs) and hierarchical strategies for extreme class imbalance.[^1]

---

## 11. Qualitative Behavior \& Interpretability

- By explicitly modeling **scene entities** and their interaction with the environment, the network can:
  - Highlight which objects (e.g., ball, card, player) drive a particular detection.
  - Provide more interpretable reasoning compared to purely global black-box CNN + RNN pipelines.[^1]
- Visualizations (in the paper) show detection boxes and attention focusing on relevant entities during events.[^1]

---

## 12. Takeaways \& Future Directions

### 12.1 Main Contributions

- A **novel end-to-end architecture** for action spotting that unifies:
  - Global environment features (RegNet‑Y + GSM).
  - Local scene entities from a pre-trained vision–language detector (GLIP).
  - An adaptive attention mechanism to select the most relevant entities.[^1]
- A **fused entities–environment representation** that improves performance, especially on small-object and long-tail classes.[^1]
- State-of-the-art results on SoccerNet‑v2, FineDiving, and FineGym, with strong improvements over both two-phase and end-to-end baselines.[^1]

### 12.2 Future Work (from the Paper)

- Introduce **Graph Neural Networks** to explicitly model relationships between entities as nodes and edges, incorporating prior knowledge about sport rules.[^1]
- Address class imbalance further by **grouping related classes** (e.g., grouping all card-related events) and performing hierarchical or group-wise classification before final label prediction.[^1]

---

## 13. Suggested 20-Minute Timing (Approx.)

You can map the above sections to a 20‑minute talk roughly as:

- 2 min – Title, context, task definition (Sections 1–3).
- 6–7 min – Method: UGL, GLIP, AAM, fusion, LTR (Sections 4–6).
- 5–6 min – Training, metrics, datasets, main results (Sections 7–9).
- 3–4 min – Ablations, interpretability, future work, key takeaways (Sections 10–12).

You can copy-paste this Markdown into your slide workflow (e.g., Marp, Reveal.js, or manually into PowerPoint/Keynote) and convert each top-level subsection into one or more slides depending on how much detail you want to show.

<div align="center">⁂</div>

[^1]: UGL.html
